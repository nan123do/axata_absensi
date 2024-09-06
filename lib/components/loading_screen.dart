import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingScreen {
  static void show() {
    if (!Get.isDialogOpen!) {
      Get.dialog(
        Center(
          child: Image.asset(
            'assets/logo/loading_2.gif',
            width: 80,
            height: 80,
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  static void hide() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}
