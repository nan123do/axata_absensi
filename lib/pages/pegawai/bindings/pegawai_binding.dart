import 'package:axata_absensi/pages/pegawai/controllers/pegawai_controller.dart';
import 'package:get/get.dart';

class PegawaiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PegawaiController>(
      () => PegawaiController(),
    );
  }
}
