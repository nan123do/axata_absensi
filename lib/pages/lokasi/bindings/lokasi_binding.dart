import 'package:axata_absensi/pages/lokasi/controllers/lokasi_controller.dart';
import 'package:get/get.dart';

class LokasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LokasiController>(
      () => LokasiController(),
    );
  }
}
