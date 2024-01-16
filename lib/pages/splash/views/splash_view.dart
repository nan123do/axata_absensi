import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:axata_absensi/pages/splash/controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AxataTheme.mainColor,
      body: Center(
        child: controller.isLoading.value
            ? Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/logo/axata_logo.png'),
                  ),
                ),
              )
            : Container(),
      ),
    );
  }
}
