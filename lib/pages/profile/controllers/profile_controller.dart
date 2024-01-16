import 'package:axata_absensi/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
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

  void logout() {
    final box = GetStorage();
    box.write('islogin', false);
    Get.offAllNamed(Routes.LOGIN);
  }
}
