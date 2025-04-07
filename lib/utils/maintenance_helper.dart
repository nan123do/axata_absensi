import 'package:axata_absensi/components/custom_toast.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/services/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaintenanceHelper {
  static SettingService settingS = SettingService();

  static getMaintenance() async {
    try {
      // Ambil data dari setting
      final setting = await settingS.getSettingById('14');
      if (setting.nilai.contains('true')) {
        // Tampilkan dialog untuk maintenance
        Future.delayed(Duration.zero, () {
          Get.dialog(
            AlertDialog(
              title: const Text("Mohon Maaf"),
              content: Text(setting.keterangan),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    if (Get.currentRoute != Routes.LOGIN) {
                      Get.offAllNamed(Routes.LOGIN);
                    }
                  },
                  child: const Text("Oke"),
                ),
              ],
            ),
            barrierDismissible: false,
          );
        });
        if (Get.currentRoute != Routes.LOGIN) {
          return Get.offAllNamed(Routes.LOGIN);
        }
      }
    } catch (e) {
      CustomToast.errorToast("Error", e.toString());
    }
  }
}
