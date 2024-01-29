import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/services/helper_service.dart';
import 'package:axata_absensi/services/login_service.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/utils/connectivity_checker.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isObsecure = true.obs;
  RxBool saveCredential = false.obs;
  RxBool isLogin = false.obs;
  RxString textIdCloud = ''.obs;
  TextEditingController usernameC = TextEditingController();
  TextEditingController passC = TextEditingController();
  LoginService serviceLogin = LoginService();
  HelperService serviceHelper = HelperService();

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getInit();
  }

  getInit() {
    textIdCloud = getJudulIdCloud().obs;

    // Get Biometric Auth
    usernameC.text = GlobalData.username;
    saveCredential.value = GlobalData.saveCredential;
    final LocalAuthentication auth = LocalAuthentication();
    try {
      auth.isDeviceSupported().then((value) async {
        if (GlobalData.isLogin && GlobalData.saveCredential && value) {
          final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Silahkan scan untuk login otomatis',
          );
          if (didAuthenticate) {
            passC.text = GlobalData.password;
            await login();
          }
        }
      });
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String getJudulIdCloud() {
    String idcloud = GlobalData.idcloud;
    String namatoko = GlobalData.keterangan.toUpperCase();

    String formattedId =
        '${idcloud.substring(0, 3)}-${idcloud.substring(3, 6)}-${idcloud.substring(6)}';
    return '$formattedId | $namatoko';
  }

  Future<void> login() async {
    if (await ConnectivityChecker.checkConnection()) {
      if (usernameC.text.isNotEmpty && passC.text.isNotEmpty) {
        isLoading.value = true;
        try {
          final box = GetStorage();
          box.write('username', usernameC.text);
          box.write('password', passC.text);
          box.write('savecredential', saveCredential.value);
          box.write('islogin', true);
          GlobalData.username = usernameC.text;
          GlobalData.password = passC.text;

          bool hasil = await serviceLogin.login();

          if (hasil) {
            String kodeSetting = serviceHelper.getKodeSetting('GajiPermenit');
            GlobalData.gajiPermenit =
                await serviceHelper.doubleSetting(kodeSetting: kodeSetting);

            CustomToast.successToast("Success", "Berhasil Login");
            await Future.delayed(Duration.zero);

            Get.offAllNamed(Routes.HOME);
          }
        } catch (e) {
          CustomToast.errorToast(
              "Error", "Terjadi Kesalahan : ${e.toString()}");
        } finally {
          isLoading.value = false;
        }
      } else {
        CustomToast.errorToast("Error", "Username dan password harus diisi");
      }
    } else {
      CustomToast.errorToast("Error", "Aktifkan data seluler atau wifi");
    }
  }
}
