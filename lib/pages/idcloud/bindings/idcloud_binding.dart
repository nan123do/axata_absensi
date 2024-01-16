import 'package:axata_absensi/pages/idcloud/controllers/idcloud_controller.dart';
import 'package:get/get.dart';

class IdCloudBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IdCloudController>(
      () => IdCloudController(),
    );
  }
}
