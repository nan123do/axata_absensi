import 'package:axata_absensi/pages/tenant/controllers/tenant_controller.dart';
import 'package:get/get.dart';

class TenantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TenantController>(
      () => TenantController(),
    );
  }
}
