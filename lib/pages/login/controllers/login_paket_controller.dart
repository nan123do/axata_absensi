import 'package:axata_absensi/components/custom_dialog.dart';
import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/components/loading_screen.dart';
import 'package:axata_absensi/models/Paket/paket_model.dart';
import 'package:axata_absensi/models/Pegawai/datapegawai_model.dart';
import 'package:axata_absensi/models/Setting/setting_model.dart';
import 'package:axata_absensi/pages/login/controllers/login_controller.dart';
import 'package:axata_absensi/pages/login/views/paket_pembayaran.dart';
import 'package:axata_absensi/pages/login/views/pembayaran_view.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/services/online/online_paket_service.dart';
import 'package:axata_absensi/services/online/online_registrasi_service.dart';
import 'package:axata_absensi/services/online/online_user_service.dart';
import 'package:axata_absensi/services/paket_service.dart';
import 'package:axata_absensi/services/registrasi_service.dart';
import 'package:axata_absensi/services/setting_service.dart';
import 'package:axata_absensi/services/user_service.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class LoginPaketController extends GetxController {
  List<DataPaketModel> listPaket = [];
  List<DataPegawaiModel> listPegawai = [];

  RxBool isLoading = false.obs;
  RxInt jumlahPegawaiAktif = 0.obs;

  // Pembayaran
  XFile? selectedImage;

  // Rekening
  SettingService serviceSetting = SettingService();
  List<SettingModel> listSetting = [];
  RxString namaBank = ''.obs;
  RxString akunBank = ''.obs;
  RxString noRekening = ''.obs;

  getInit() async {
    await handleDataPaket();
    await handleGetUser();
    hitungPegawaiAktif();
  }

  void hitungPegawaiAktif() {
    jumlahPegawaiAktif.value =
        listPegawai.where((pegawai) => pegawai.isDisabled == false).length;
  }

  handleDataPaket() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlinePaketService serviceOnline = OnlinePaketService();
      listPaket = await serviceOnline.getDataPaket();
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      PaketService service = PaketService();
      listPaket = await service.getDataPaket();
    }

    // Pisahkan elemen yang memenuhi kondisi dan elemen lainnya
    var paketDefault = listPaket
        .where((paket) => paket.harga == 0 && paket.keterangan == "default")
        .toList();
    var paketLainnya = listPaket
        .where((paket) => !(paket.harga == 0 && paket.keterangan == "default"))
        .toList();

    listPaket = [...paketDefault, ...paketLainnya];
  }

  handleGetUser() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineUserService serviceOnline = OnlineUserService();
      listPegawai = await serviceOnline.getDataPegawai();
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      UserService serviceUser = UserService();
      listPegawai = await serviceUser.getDataPegawai(namaPegawai: '');
    }
  }

  handleDataRekening() async {
    LoadingScreen.show();
    try {
      listSetting = await serviceSetting.getSetting();
      for (var i = 0; i < listSetting.length; i++) {
        if (listSetting[i].nama.contains('namabank')) {
          namaBank.value = listSetting[i].nilai;
        }
        if (listSetting[i].nama.contains('akunbank')) {
          akunBank.value = listSetting[i].nilai;
        }
        if (listSetting[i].nama.contains('norekening')) {
          noRekening.value = listSetting[i].nilai;
          int length = noRekening.value.length;
          if (length > 0 || length < 13) {
            noRekening.value =
                '${noRekening.substring(0, 4)}-${noRekening.substring(4, 8)}-${noRekening.substring(8)}';
          } else {
            noRekening.value =
                '${noRekening.substring(0, 4)}-${noRekening.substring(4, 8)}-${noRekening.substring(8, 12)}-${noRekening.substring(12)}';
          }
        }
      }
      LoadingScreen.hide();
    } catch (e) {
      LoadingScreen.hide();
      CustomToast.errorToast("Error", e.toString());
    } finally {}
  }

  goPembayaranPage(DataPaketModel data) async {
    // Pegawai Aktif > Jumlah Pegawai
    if (jumlahPegawaiAktif > data.jumlahPegawai) {
      CustomAlertDialog.showCloseDialog(
        title: "Perhatian !",
        message:
            "Anda akan downgrade ke ${data.nama} (Maksimum ${data.jumlahPegawai} pegawai)\n\nSaat ini, Anda memiliki ${jumlahPegawaiAktif.value} pegawai aktif yang melebihi batas dari paket yang Anda pilih.\n\nUntuk melanjutkan, Anda perlu menonaktifkan ${jumlahPegawaiAktif.value - data.jumlahPegawai} pegawai agar sesuai dengan batas maksimal pegawai pada ${data.nama}",
        textButton: 'Nonaktifkan Data Pegawai',
        onClose: () async {
          Get.back();
          await Get.toNamed(
            Routes.PEGAWAI,
            arguments: {
              'jumlahPegawai': data.jumlahPegawai,
            },
          );
          getInit();
        },
      );
      return;
    }
    // Cek Paket Trial konfirmasi
    if (data.harga == 0 && data.keterangan!.toLowerCase() == 'default') {
      await handleKirimLangganan(data);
      await CustomAlertDialog.showCloseDialog(
        type: 'success',
        title: "Aktivasi Paket Berhasil !",
        message: "Terima kasih telah memilih Axata Absensi",
        textButton: 'Yakin',
        autoCloseDurationInSeconds: 2,
        onClose: () async {
          Get.back();
          final loginC = Get.find<LoginController>();
          loginC.login();
          // Get.offAllNamed(Routes.LOGIN);
        },
      );
      return;
    } else {
      CustomAlertDialog.showCloseDialog(
        type: 'error',
        title: "Perhatian !",
        message: "Apakah anda yakin tidak mencoba trial dulu?",
        textButton: 'Yakin',
        onClose: () async {
          Get.back();
          await handleDataRekening();
          Get.to(
            () => PembayaranLoginView(
              controller: this,
              paket: data,
            ),
          );
        },
      );
      return;
    }
  }

// Fungsi untuk memilih gambar dari kamera atau galeri
  Future<void> pickImage(ImageSource source) async {
    isLoading(true);
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        selectedImage = image;
        update();
      }
    } catch (e) {
      CustomToast.errorToast('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Fungsi untuk menampilkan pilihan kamera atau galeri
  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Ambil dari Kamera'),
                onTap: () {
                  Get.back();
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Unggah dari Galeri'),
                onTap: () {
                  Get.back();
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> handleKirimLangganan(DataPaketModel data) async {
    if (selectedImage == null && data.harga != 0) {
      CustomToast.errorToast('Error', 'Bukti masih kosong');
      return;
    }

    try {
      if (data.harga != 0) {}
      LoadingScreen.show();
      await handleApiKirimLangganan(data);
      LoadingScreen.hide();
      if (data.harga != 0) {
        await CustomToast.successToast(
          'Success',
          'Berhasil Mengirim Permintaan ke Admin',
        );
        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      LoadingScreen.hide();
      isLoading(false);
      CustomToast.errorToast('Error', '$e');
    }
  }

  handleApiKirimLangganan(DataPaketModel data) async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineRegistrasiService serviceOnline = OnlineRegistrasiService();
      await serviceOnline.simpanRegistrasi(
        idpaket: data.id.toString(),
        idtenant: GlobalData.idPenyewa,
        jumlahPegawai: data.jumlahPegawai.toString(),
        totalHarga: data.harga.toString(),
        file: selectedImage,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      RegistrasiService service = RegistrasiService();
      await service.simpanRegistrasi(
        idpaket: data.id.toString(),
        jumlahPegawai: data.jumlahPegawai.toString(),
        totalHarga: data.harga.toString(),
        file: selectedImage,
      );
    }
  }

  goPaketLangganan() async {
    LoadingScreen.show();
    try {
      await getInit();
      LoadingScreen.hide();
    } catch (e) {
      LoadingScreen.hide();
      CustomToast.errorToast("Error", e.toString());
    } finally {
      LoadingScreen.hide();
    }

    Get.to(
      () => PaketPembayaranLoginView(controller: this),
    );
  }
}
