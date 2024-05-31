import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool saveCredential = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getInit();
  }

  getInit() {
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
}
