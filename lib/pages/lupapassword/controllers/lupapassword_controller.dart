import 'package:axata_absensi/components/custom_dialog.dart';
import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/components/loading_screen.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/services/online/online_login_service.dart';
import 'package:axata_absensi/utils/enums.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LupaPasswordController extends GetxController {
  TextEditingController emailC = TextEditingController();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getInit();
  }

  getInit() {
    isLoading.value = false;
  }

  handleSimpan() async {
    if (emailC.text == '') {
      CustomToast.errorToast("Error", 'Email masih kosong.');
      return;
    }

    final RegExp emailRegexp = RegExp(
      r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );

    if (!emailRegexp.hasMatch(emailC.text)) {
      CustomToast.errorToast("Error", 'Format email tidak valid.');
      return;
    }

    try {
      LoadingScreen.show();
      await handleResetPassword();
      LoadingScreen.hide();
      CustomAlertDialog.showCloseDialog(
        title: 'Reset Password',
        message:
            'Email untuk reset password berhasil dikirimkan di folder inbox/spam email Anda.',
        onClose: () {
          Get.back();
          Get.offAllNamed(Routes.LOGIN);
        },
      );
    } catch (e) {
      LoadingScreen.hide();
      CustomToast.errorToast('Error', '$e');
    }
  }

  handleResetPassword() async {
    if (GlobalData.globalKoneksi == Koneksi.online) {
      OnlineLoginService serviceOnline = OnlineLoginService();
      await serviceOnline.resetPasswordEmail(
        email: emailC.text,
      );
    } else if (GlobalData.globalKoneksi == Koneksi.axatapos) {}
  }
}
