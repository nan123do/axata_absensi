import 'package:axata_absensi/components/loading.dart';
import 'package:axata_absensi/pages/smileface/controllers/smileface_controller.dart';
import 'package:axata_absensi/pages/smileface/views/smileface12_view.dart';
import 'package:axata_absensi/pages/smileface/views/smilefaceother_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:axata_absensi/utils/theme.dart';

class SmileFaceView extends GetView<SmileFaceController> {
  const SmileFaceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AxataTheme.bgGrey,
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingPage()
            : Obx(
                () => controller.versionsToCheck.contains(controller.androidVersion.value)
                    ? SmileFaceAndroid12View(controller: controller)
                    : controller.cameraController!.value.isInitialized
                        ? SmileFaceAndroidOtherView(controller: controller)
                        : Container(),
              ),
      ),
    );
  }
}
