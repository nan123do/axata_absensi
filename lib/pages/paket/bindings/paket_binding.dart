import 'package:axata_absensi/pages/paket/controllers/paket_controller.dart';
import 'package:get/get.dart';

class PaketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaketController>(
      () => PaketController(),
    );
  }
}
