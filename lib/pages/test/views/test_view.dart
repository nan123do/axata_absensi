import 'package:axata_absensi/pages/test/controllers/test_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TestView extends GetView<TestController> {
  const TestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trust Location Plugin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(
          () => Center(
            child: Column(
              children: [
                Text('Mock Location: ${controller.isMockLocation}'),
                Text(
                  'Latitude: ${controller.latitude}, Longitude: ${controller.longitude}',
                ),
                GestureDetector(
                  onTap: () => controller.refreshMock(context),
                  child: Container(
                    color: AxataTheme.mainColor,
                    padding: EdgeInsets.all(20.r),
                    child: const Text(
                      'Refresh',
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
