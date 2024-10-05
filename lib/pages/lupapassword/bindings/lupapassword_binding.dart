import 'package:axata_absensi/pages/lupapassword/controllers/lupapassword_controller.dart';
import 'package:get/get.dart';

class LupaPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LupaPasswordController>(
      () => LupaPasswordController(),
    );
  }
}
