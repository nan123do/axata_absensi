import 'package:axata_absensi/components/custom_dialog.dart';
import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/components/loading_screen.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/services/online/online_tenant_service.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/maintenance_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  TextEditingController namaC = TextEditingController();
  TextEditingController alamatC = TextEditingController();
  TextEditingController usernameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController firstnameC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController passwordKC = TextEditingController();
  TextEditingController telpC = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isObsecurePassword = true.obs;
  RxBool isObsecurePasswordK = true.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getInit();
  }

  getInit() async {
    await MaintenanceHelper.getMaintenance();
    isLoading.value = false;
  }

  errorSaveMesssage(String title) {
    CustomToast.errorToast("Error", title);
    isLoading.value = false;
  }

  handleSimpan() async {
    if (namaC.text == '') {
      errorSaveMesssage('Nama Perusahaan harus diisi.');
      return;
    }

    if (usernameC.text == '') {
      errorSaveMesssage('Username admin harus diisi.');
      return;
    }

    if (emailC.text == '') {
      errorSaveMesssage('Email admin harus diisi.');
      return;
    }

    final RegExp emailRegexp = RegExp(
      r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );

    if (!emailRegexp.hasMatch(emailC.text)) {
      errorSaveMesssage('Format email tidak valid.');
      return;
    }

    if (telpC.text == '') {
      errorSaveMesssage('No Telpon harus diisi.');
      return;
    }

    if (firstnameC.text == '') {
      errorSaveMesssage('Nama admin harus diisi.');
      return;
    }

    if (passwordC.text == '') {
      errorSaveMesssage('Password harus diisi.');
      return;
    }

    if (passwordC.text != passwordKC.text) {
      errorSaveMesssage('Password dan konfirmasi password harus sama');
      return;
    }

    try {
      LoadingScreen.show();
      await handleTambahPenyewa();
      LoadingScreen.hide();
      CustomAlertDialog.showCloseDialog(
        title: 'Aktivasi Email',
        message:
            'Email aktivasi berhasil dikirimkan di folder inbox/spam Anda.',
        onClose: () {
          Get.back();
          CustomToast.successToast(
              'Success', 'Berhasil mendaftarkan perusahaan');
          Get.offAllNamed(Routes.LOGIN);
        },
      );
    } catch (e) {
      LoadingScreen.hide();
      CustomToast.errorToast('Error', '$e');
    }
  }

  handleTambahPenyewa() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineTenantService serviceOnline = OnlineTenantService();
      await serviceOnline.tambahTenant(
        username: usernameC.text,
        nama: namaC.text,
        email: emailC.text,
        alamat: alamatC.text,
        firstname: firstnameC.text,
        password: passwordC.text,
        telp: telpC.text,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }
}
