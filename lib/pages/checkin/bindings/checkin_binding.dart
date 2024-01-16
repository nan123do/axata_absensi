import 'package:axata_absensi/pages/checkin/controllers/checkin_controller.dart';
import 'package:get/get.dart';

class CheckInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckInController>(
      () => CheckInController(),
    );
  }
}
