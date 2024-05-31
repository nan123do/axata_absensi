import 'package:axata_absensi/pages/shift/controllers/shift_controller.dart';
import 'package:get/get.dart';

class ShiftBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShiftController>(
      () => ShiftController(),
    );
  }
}
