import 'package:axata_absensi/components/custom_dialog.dart';
import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/components/loading_screen.dart';
import 'package:axata_absensi/models/Paket/paket_model.dart';
import 'package:axata_absensi/models/Pegawai/datapegawai_model.dart';
import 'package:axata_absensi/models/Registrasi/registrasi_model.dart';
import 'package:axata_absensi/models/Setting/cloud_setting_model.dart';
import 'package:axata_absensi/models/Setting/setting_model.dart';
import 'package:axata_absensi/pages/checkin/controllers/checkin_controller.dart';
import 'package:axata_absensi/pages/setting/views/paket_pembayaran.dart';
import 'package:axata_absensi/pages/setting/views/pembayaran_view.dart';
import 'package:axata_absensi/pages/setting/views/riwayat_pembayaran.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/services/cloud_setting_service.dart';
import 'package:axata_absensi/services/online/online_paket_service.dart';
import 'package:axata_absensi/services/online/online_registrasi_service.dart';
import 'package:axata_absensi/services/online/online_setting_service.dart';
import 'package:axata_absensi/services/online/online_user_service.dart';
import 'package:axata_absensi/services/paket_service.dart';
import 'package:axata_absensi/services/registrasi_service.dart';
import 'package:axata_absensi/services/setting_service.dart';
import 'package:axata_absensi/services/user_service.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/maintenance_helper.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class SettingController extends GetxController {
  final checkInController = Get.put(CheckInController());
  TextEditingController radiusC = TextEditingController(text: '');
  TextEditingController latLongC = TextEditingController(text: '');
  TextEditingController smilePercentC = TextEditingController(text: '');
  TextEditingController smileDurationC = TextEditingController(text: '');
  RxBool isLoading = false.obs;
  RxBool checkoutInStore = false.obs;
  RxBool isFirst = true.obs;
  RxBool isPending = true.obs;
  RxString location = ''.obs;
  RxString ubahLocation = ''.obs;

  late Position currentPosition;
  late GoogleMapController mapController;
  RxMap<String, dynamic> office = <String, dynamic>{}.obs;
  SettingService serviceSetting = SettingService();

  List<DataPegawaiModel> listPegawai = [];
  List<DataPaketModel> listPaket = [];
  List<DataRegistrasiModel> listRegistrasi = [];
  XFile? selectedImage;
  DataRegistrasiModel? lastPaket;
  RxInt jumlahPegawaiAktif = 0.obs;
  List<SettingModel> listSetting = [];

  // Rekening
  RxString namaBank = ''.obs;
  RxString akunBank = ''.obs;
  RxString noRekening = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getInit();
  }

  getInit({String type = ''}) async {
    isLoading.value = true;
    try {
      await MaintenanceHelper.getMaintenance();
      office.value = Map<String, dynamic>.from(GlobalData.office);
      if (type == 'location' || isFirst.value) {
        location.value = GlobalData.alamattoko;
        // await getLocation();
      }
      radiusC.text = office['radius'].round().toString();
      latLongC.text = '${office['latitude']},${office['longitude']}';
      smilePercentC.text = '${GlobalData.smilePercent}';
      smileDurationC.text = '${GlobalData.smileDuration}';

      // Get Count User & Data Registrasi
      await handleGetUser();
      await handleGetRegistrasi();
      await handleGetSetting();
      hitungPegawaiAktif();
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void hitungPegawaiAktif() {
    jumlahPegawaiAktif.value =
        listPegawai.where((pegawai) => pegawai.isDisabled == false).length;
  }

  handleGetSetting() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      CloudSettingService service = CloudSettingService();
      final data = await service.getDataCloudSetting();
      CloudSetting coInStore =
          data.singleWhere((e) => e.settingKey == 'checkout_instore');
      checkoutInStore.value = coInStore.settingValue == 'true' ? true : false;
    }
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

  handleGetRegistrasi() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineRegistrasiService serviceOnline = OnlineRegistrasiService();
      listRegistrasi = await serviceOnline.getDataRegistrasi(
        idTenant: GlobalData.idPenyewa,
        status: '',
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      RegistrasiService service = RegistrasiService();
      listRegistrasi = await service.getDataRegistrasi(
        idcloud: GlobalData.idcloud,
      );
    }

    // Cek Pending Atau Tidak
    if (listRegistrasi.isEmpty) {
      isPending.value = false;
    } else {
      bool hasPending = listRegistrasi.any(
        (registrasi) => registrasi.status == '2',
      );
      isPending.value = hasPending;

      // Menentukan lastRegistrasi sebagai data pertama dengan status 1
      int lastIndex =
          listRegistrasi.indexWhere((registrasi) => registrasi.status == '1');
      if (lastIndex != -1) {
        lastPaket = listRegistrasi[lastIndex];
      }
    }
  }

  getLocation() async {
    Map<String, dynamic> data = await checkInController.determinePosition();
    currentPosition = data['position'];
    List<Placemark> placemarks = await placemarkFromCoordinates(
      office['latitude'],
      office['longitude'],
    );
    String address =
        "${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality}";
    location.value = address;
    ubahLocation.value = location.value.toString();
  }

  Polygon createRadiusPolygon(LatLng center, double radiusInMeters) {
    return checkInController.createRadiusPolygon(center, radiusInMeters);
  }

  updateRadius(String value) {
    if (value != '') {
      office['radius'] = double.parse(value);
    }
  }

  handleThisLoc() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    office['latitude'] = position.latitude;
    office['longitude'] = position.longitude;

    // Konversi posisi ke alamat
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String address =
        "${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality}";
    ubahLocation.value = address;

    latLongC.text = '${position.latitude},${position.longitude}';

    // Perbarui map dan polygon
    mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ),
    );

    // Update polygon
    updatePolygon();
  }

  Future<void> updateMapLocation() async {
    if (latLongC.text.isNotEmpty) {
      List<String> latLong = latLongC.text.split(',');
      if (latLong.length == 2) {
        double latitude = double.tryParse(latLong[0]) ?? office['latitude'];
        double longitude = double.tryParse(latLong[1]) ?? office['longitude'];
        office['latitude'] = latitude;
        office['longitude'] = longitude;

        // Konversi posisi ke alamat
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        String address =
            "${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality}";
        ubahLocation.value = address;

        // Opsi untuk langsung memperbarui tampilan map
        mapController.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(latitude, longitude),
          ),
        );

        // Update polygon
        updatePolygon();
      }
    }
  }

  void updatePolygon() {
    createRadiusPolygon(
      LatLng(office['latitude'], office['longitude']),
      double.parse(office['radius'].toString()),
    );
  }

  Future<void> handleSimpan() async {
    try {
      if (GlobalData.globalKoneksi == Koneksi.online) {
        OnlineSettingService serviceOnline = OnlineSettingService();
        await serviceOnline.postDataSetting(
          latitude: office['latitude'].toString(),
          longitude: office['longitude'].toString(),
          radius: office['radius'].toString(),
          smileDuration: smileDurationC.text,
          smilePercent: smilePercentC.text,
        );
      } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
        await serviceSetting.postDataSetting(
          latitude: office['latitude'].toString(),
          longitude: office['longitude'].toString(),
          radius: office['radius'].toString(),
          smileDuration: smileDurationC.text,
          smilePercent: smilePercentC.text,
        );
      }
      GlobalData.smileDuration = int.parse(smileDurationC.text);
      GlobalData.smilePercent = int.parse(smilePercentC.text);
      GlobalData.office = office;
      location = ubahLocation;
      Get.back();
      CustomToast.successToast("Success", "Setting Berhasil Diupdate");
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  ubahAktifkanLokasiValidasiAbsenKeluar(bool value) {
    checkoutInStore.value = value;
    handleUpdateCloudSetting(
      'checkout_instore',
      value == true ? 'true' : 'false',
    );
  }

  handleUpdateCloudSetting(String settingKey, String settingValue) async {
    try {
      if (GlobalData.globalKoneksi == Koneksi.axatapos) {
        CloudSettingService service = CloudSettingService();
        await service.updateCloudSetting(
          settingKey: settingKey,
          settingValue: settingValue,
        );
      }
      CustomToast.successToast("Success", "Setting Berhasil Diupdate");
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  handleDataPaket() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlinePaketService serviceOnline = OnlinePaketService();
      listPaket = await serviceOnline.getDataPaket();
      listPaket.removeWhere(
        (paket) => paket.harga == 0 && paket.keterangan == "default",
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      PaketService service = PaketService();
      listPaket = await service.getDataPaket();
      listPaket.removeWhere(
        (paket) => paket.harga == 0 && paket.keterangan == "default",
      );
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
    } finally {
      isLoading.value = false;
    }
  }

  goPaketLangganan() async {
    LoadingScreen.show();
    try {
      await handleDataPaket();
      LoadingScreen.hide();
    } catch (e) {
      LoadingScreen.hide();
      CustomToast.errorToast("Error", e.toString());
    } finally {
      LoadingScreen.hide();
    }

    Get.to(
      () => PaketPembayaranView(controller: this),
    );
  }

  goRiwayatTransaksi() async {
    Get.to(
      () => RiwayatPembayaranView(controller: this),
    );
  }

  goPembayaranPage(DataPaketModel data) async {
    await handleDataRekening();
    if (lastPaket != null) {
      if (jumlahPegawaiAktif > data.jumlahPegawai) {
        CustomAlertDialog.showCloseDialog(
          title: "Perhatian !",
          message:
              "Anda akan downgrade ke ${data.nama} (Maksimum ${data.jumlahPegawai} pegawai)\n\nSaat ini, Anda memiliki ${jumlahPegawaiAktif.value} pegawai aktif yang melebihi batas dari paket yang Anda pilih.\n\nUntuk melanjutkan, Anda perlu menonaktifkan ${jumlahPegawaiAktif.value - data.jumlahPegawai} pegawai agar sesuai dengan batas maksimal pegawai pada ${data.nama}",
          textButton: 'Nonaktifkan Data Pegawai',
          onClose: () async {
            Get.back();
            await Get.toNamed(Routes.PEGAWAI);
            getInit();
          },
        );
        return;
      }

      if (lastPaket!.paket.id.toString() != data.id) {
        CustomAlertDialog.dialogTwoButton(
          title: "KONFIRMASI PERUBAHAN PAKET",
          message:
              "Paket sebelumnya akan hilang dan digantikan dengan paket baru.",
          textContinue: 'Lanjut',
          textBack: 'Batal',
          onContinue: () {
            Get.back();
            Get.to(
              () => PembayaranView(
                controller: this,
                paket: data,
              ),
            );
          },
          onCancel: () {
            Get.back();
          },
        );
      } else {
        Get.to(
          () => PembayaranView(
            controller: this,
            paket: data,
          ),
        );
      }
    } else {
      Get.to(
        () => PembayaranView(
          controller: this,
          paket: data,
        ),
      );
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
    if (selectedImage == null) {
      CustomToast.errorToast('Error', 'Bukti masih kosong');
      return;
    }

    try {
      isLoading(true);
      LoadingScreen.show();
      await handleApiKirimLangganan(data);
      LoadingScreen.hide();
      await CustomToast.successToast(
        'Success',
        'Berhasil Mengirim Permintaan ke Admin',
      );
      await Future.delayed(const Duration(seconds: 1));
      isLoading(false);
      Get.offAllNamed(Routes.HOME);
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
}
