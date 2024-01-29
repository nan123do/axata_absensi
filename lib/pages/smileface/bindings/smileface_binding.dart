import 'package:axata_absensi/pages/smileface/controllers/smileface_controller.dart';
import 'package:get/get.dart';

class SmileFaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SmileFaceController>(
      () => SmileFaceController(),
    );
  }
}
