import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/components/loading_screen.dart';
import 'package:axata_absensi/models/Pegawai/datapegawai_model.dart';
import 'package:axata_absensi/pages/pegawai/views/save_pegawai.dart';
import 'package:axata_absensi/pages/pegawai/views/ubah_password.dart';
import 'package:axata_absensi/services/online/online_user_service.dart';
import 'package:axata_absensi/services/user_service.dart';
import 'package:axata_absensi/utils/datehelper.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/maintenance_helper.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PegawaiController extends GetxController {
  TextEditingController usernameC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController passwordKC = TextEditingController();
  TextEditingController alamatC = TextEditingController();
  TextEditingController noTelpC = TextEditingController();
  RxBool isLoading = false.obs;
  RxList<DataPegawaiModel> listPegawai = RxList<DataPegawaiModel>([]);
  RxList<DataPegawaiModel> sortPegawai = RxList<DataPegawaiModel>([]);
  Rx<DateTime> dateMasuk = DateTime.now().obs;
  RxString id = ''.obs;

  UserService serviceUser = UserService();
  int jumlahPegawaiAktif = 0;
  final args = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    getInit();
  }

  getInit() async {
    isLoading.value = true;
    try {
      await MaintenanceHelper.getMaintenance();
      await handleDataPegawai();
      sortPegawai.value = sortingPegawai();
      hitungPegawaiAktif();
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
      LoadingScreen.hide();
    } finally {
      LoadingScreen.hide();
      isLoading.value = false;
    }
  }

  handleDataPegawai() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineUserService serviceOnline = OnlineUserService();
      listPegawai.value = await serviceOnline.getDataPegawai();
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      listPegawai.value = await serviceUser.getDataPegawai(namaPegawai: '');
    }
  }

  void hitungPegawaiAktif() {
    jumlahPegawaiAktif =
        listPegawai.where((pegawai) => pegawai.isDisabled == false).length;
  }

  List<DataPegawaiModel> sortingPegawai() {
    return List.from(listPegawai)
      ..sort((a, b) {
        // Jika a.statusAktif == true dan b.statusAktif == false, maka a di atas
        if (a.isDisabled && !b.isDisabled) {
          return 1;
        } else if (!a.isDisabled && b.isDisabled) {
          return -1;
        } else {
          return 0;
        }
      });
  }

  void goDialog(DataPegawaiModel data) {
    if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      Get.defaultDialog(
        title: '',
        titlePadding: EdgeInsets.symmetric(vertical: 25.h),
        titleStyle: const TextStyle(fontSize: 0),
        content: Column(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
                goSetDisablePegawai(data);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  data.isDisabled == false ? 'Nonaktifkan' : 'Aktifkan',
                  style: AxataTheme.threeSmall,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      Get.defaultDialog(
        title: '',
        titlePadding: EdgeInsets.symmetric(vertical: 25.h),
        titleStyle: const TextStyle(fontSize: 0),
        content: Column(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
                goUbahPage(data);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Ubah',
                  style: AxataTheme.threeSmall,
                ),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                Get.back();
                goUbahPasswordPage(data);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Ubah Password',
                  style: AxataTheme.threeSmall,
                ),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                Get.back();
                goSetDisablePegawai(data);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  data.isDisabled == false ? 'Nonaktifkan' : 'Aktifkan',
                  style: AxataTheme.threeSmall,
                ),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () => goHapusPage(data),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Hapus',
                  style: AxataTheme.threeSmall,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  goAddPage() {
    if (jumlahPegawaiAktif >= GlobalData.maxPegawai) {
      CustomToast.errorToast('Error',
          'Jumlah pegawai aktif tidak boleh melebihi maksimal pegawai');
      return;
    }

    id.value = '';
    usernameC.text = '';
    namaC.text = '';
    emailC.text = '';
    passwordC.text = '';
    passwordKC.text = '';
    alamatC.text = '';
    noTelpC.text = '';

    dateMasuk.value = DateTime.now();

    Get.to(
      () => SavePegawai(
        controller: this,
        isAdd: true,
      ),
      transition: Transition.rightToLeftWithFade,
    );
  }

  goUbahPage(DataPegawaiModel data) {
    id.value = data.kode;
    usernameC.text = data.username;
    namaC.text = data.nama;
    emailC.text = data.email;
    passwordC.text = '';
    passwordKC.text = '';
    alamatC.text = data.alamat;
    noTelpC.text = data.telp;

    dateMasuk.value = data.tglMasuk;

    Get.to(
      () => SavePegawai(
        controller: this,
        isAdd: false,
      ),
      transition: Transition.rightToLeftWithFade,
    );
  }

  goSetDisablePegawai(DataPegawaiModel data) async {
    // Cek pegawai aktif harus <= GlobalData.maxPegawai
    int maxPegawai = GlobalData.maxPegawai;
    if (GlobalData.maxPegawai == 0) {
      maxPegawai = args['jumlahPegawai'];
    }
    if (jumlahPegawaiAktif >= maxPegawai && !data.isDisabled == false) {
      CustomToast.errorToast('Error',
          'Jumlah pegawai aktif tidak boleh melebihi maksimal pegawai');
      return;
    }

    try {
      LoadingScreen.show();
      await handleSetDisablePegawai(data);
      await handleDataPegawai();
      sortPegawai.value = sortingPegawai();
      hitungPegawaiAktif();
      LoadingScreen.hide();
      CustomToast.successToast('Success',
          'Berhasil ${data.isDisabled == false ? 'Menonaktifkan' : 'Mengaktifkan'} Pegawai');
    } catch (e) {
      LoadingScreen.hide();
      CustomToast.errorToast('Error', '$e');
    }
  }

  goUbahPasswordPage(DataPegawaiModel data) {
    id.value = data.kode;
    passwordC.text = '';
    passwordKC.text = '';

    Get.to(
      () => UbahPasswordPegawai(
        controller: this,
      ),
      transition: Transition.rightToLeftWithFade,
    );
  }

  goHapusPage(DataPegawaiModel data) async {
    try {
      id.value = data.kode;
      await handleHapusPegawai();
      Get.back();
      CustomToast.successToast('Success', 'Berhasil Menghapus Pegawai');
      getInit();
    } catch (e) {
      CustomToast.errorToast('Error', '$e');
    }
  }

  errorSaveMesssage(String title) {
    CustomToast.errorToast("Error", title);
    isLoading.value = false;
  }

  handleSimpan(bool isAdd) async {
    try {
      if (usernameC.text == '') {
        errorSaveMesssage('Username harus diisi.');
        return;
      }

      if (namaC.text == '') {
        errorSaveMesssage('Nama harus diisi.');
        return;
      }

      if (emailC.text == '') {
        errorSaveMesssage('Email harus diisi.');
        return;
      }

      final RegExp emailRegexp = RegExp(
        r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
      );
      if (!emailRegexp.hasMatch(emailC.text)) {
        errorSaveMesssage('Format email tidak valid.');
        return;
      }

      LoadingScreen.show();
      if (isAdd) {
        if (passwordC.text == '') {
          errorSaveMesssage('Password harus diisi.');
          return;
        }

        if (passwordKC.text == '') {
          errorSaveMesssage('Konfirmasi Password harus diisi.');
          return;
        }

        if (passwordC.text != passwordKC.text) {
          errorSaveMesssage('Password dan Konfirmasi Password harus sama.');
          return;
        }
        await handleTambahPegawai();
        LoadingScreen.hide();
        Get.back();
        CustomToast.successToast('Success', 'Berhasil Menambah Pegawai');
      } else {
        LoadingScreen.hide();
        await handleUbahPegawai();
        Get.back();
        CustomToast.successToast('Success', 'Berhasil Mengubah Pegawai');
      }

      getInit();
    } catch (e) {
      CustomToast.errorToast('Error', '$e');
    }
  }

  handleUbahPassword() async {
    try {
      if (passwordC.text == '') {
        errorSaveMesssage('Password harus diisi.');
        return;
      }

      if (passwordKC.text == '') {
        errorSaveMesssage('Konfirmasi Password harus diisi.');
        return;
      }

      if (passwordC.text != passwordKC.text) {
        errorSaveMesssage('Password dan Konfirmasi Password harus sama.');
        return;
      }

      await handleUbahPasswordPegawai();
      Get.back();
      CustomToast.successToast('Success', 'Berhasil Mengubah Password');
    } catch (e) {
      CustomToast.errorToast('Error', '$e');
    }
  }

  handleTambahPegawai() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineUserService serviceOnline = OnlineUserService();
      await serviceOnline.tambahPegawai(
        username: usernameC.text,
        nama: namaC.text,
        email: emailC.text,
        password: passwordC.text,
        alamat: alamatC.text,
        telp: noTelpC.text,
        tglMasuk: DateFormat('yyyy-MM-dd').format(dateMasuk.value),
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  handleUbahPegawai() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineUserService serviceOnline = OnlineUserService();
      await serviceOnline.ubahPegawai(
        id: id.value,
        username: usernameC.text,
        nama: namaC.text,
        email: emailC.text,
        alamat: alamatC.text,
        telp: noTelpC.text,
        tglMasuk: DateFormat('yyyy-MM-dd').format(dateMasuk.value),
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  handleSetDisablePegawai(DataPegawaiModel data) async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineUserService serviceOnline = OnlineUserService();

      await serviceOnline.ubahStatusNonaktifPegawai(
        id: data.kode,
        isDisabled: !data.isDisabled,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {
      UserService userS = UserService();
      userS.ubahStatusNonaktifPegawai(
        kodePegawai: data.kode,
        status: !data.isDisabled,
      );
    }
  }

  handleUbahPasswordPegawai() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineUserService serviceOnline = OnlineUserService();
      await serviceOnline.ubahPassword(
        id: id.value,
        oldpassword: '',
        newpassword: passwordC.text,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  handleHapusPegawai() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineUserService serviceOnline = OnlineUserService();
      await serviceOnline.hapusPegawai(
        id: id.value,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }

  handleDatePick(BuildContext context) {
    DateTime now = DateTime.now();
    updateDate(DateTime newDate, String newDateText) {
      if (newDate.isBefore(now)) {
        dateMasuk.value = newDate;
      } else {
        CustomToast.errorToast(
            'Eroor', 'Tanggal tidak boleh lebih dari hari ini');
      }
    }

    DateHelper.listDatePickerV2(
      context,
      'dd/MM/yyyy',
      dateMasuk.value,
      '',
      updateDate,
    );
  }
}
