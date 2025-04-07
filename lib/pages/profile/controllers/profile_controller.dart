import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/components/loading_screen.dart';
import 'package:axata_absensi/pages/profile/views/password_ubah.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/services/online/online_user_service.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/maintenance_helper.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  TextEditingController oldPasswordC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController passwordKC = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool saveCredential = false.obs;
  RxBool isObsecureOldPassword = true.obs;
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
    saveCredential.value = GlobalData.saveCredential;
    isLoading.value = false;
  }

  void logout() {
    final box = GetStorage();
    box.write('islogin', false);
    Get.offAllNamed(Routes.LOGIN);
  }

  handleSimpanInfoLogin(bool status) {
    saveCredential.value = status;
    final box = GetStorage();
    box.write('savecredential', status);
    GlobalData.saveCredential = status;
  }

  goUbahPassword() {
    oldPasswordC.text = '';
    passwordC.text = '';
    passwordKC.text = '';
    isObsecureOldPassword.value = true;
    isObsecurePassword.value = true;
    isObsecurePasswordK.value = true;

    Get.to(
      () => ChangePasswordView(controller: this),
    );
  }

  handleUbahPassword() async {
    if (passwordC.text == '') {
      CustomToast.errorToast("Error", 'Password harus diisi.');
      return;
    }

    if (passwordC.text != passwordKC.text) {
      CustomToast.errorToast(
          "Error", 'Password dan konfirmasi password harus sama.');
      return;
    }

    try {
      LoadingScreen.show();
      await handleAPIUbahPassword();
      LoadingScreen.hide();
      Get.back();
      CustomToast.successToast('Success', 'Password Berhasil Diubah');
    } catch (e) {
      LoadingScreen.hide();
      CustomToast.errorToast('Error', '$e');
    }
  }

  handleAPIUbahPassword() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineUserService serviceOnline = OnlineUserService();
      await serviceOnline.ubahPassword(
        id: PegawaiData.kodepegawai,
        oldpassword: oldPasswordC.text,
        newpassword: passwordC.text,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }
}
