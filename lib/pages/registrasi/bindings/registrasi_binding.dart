import 'package:axata_absensi/pages/registrasi/controllers/registrasi_controller.dart';
import 'package:get/get.dart';

class RegistrasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegistrasiController>(
      () => RegistrasiController(),
    );
  }
}
