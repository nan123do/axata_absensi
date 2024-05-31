import 'package:axata_absensi/pages/absensi/controllers/absensi_controller.dart';
import 'package:get/get.dart';

class AbsensiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbsensiController>(
      () => AbsensiController(),
    );
  }
}
