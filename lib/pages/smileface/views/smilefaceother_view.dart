import 'package:axata_absensi/pages/smileface/controllers/smileface_controller.dart';
import 'package:axata_absensi/utils/pegawai_data.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:axata_absensi/utils/theme.dart';

class SmileFaceAndroidOtherView extends StatelessWidget {
  const SmileFaceAndroidOtherView({
    super.key,
    required this.controller,
  });
  final SmileFaceController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 300.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 60.w,
            ),
            decoration: AxataTheme.styleGradient,
            alignment: Alignment.center,
            child: Text(
              'Senyum Dulu 😊',
              style: AxataTheme.twoBold.copyWith(
                color: AxataTheme.white,
              ),
            ),
          ),
          SizedBox(height: 72.h),
          Container(
            height: 0.65.sh,
            padding: EdgeInsets.all(20.r),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CameraPreview(controller.cameraController!),
                  GestureDetector(
                    onTap: () => controller.checkIn(),
                    child: Visibility(
                      visible: PegawaiData.nama.toLowerCase().contains('nando'),
                      child: Positioned(
                        bottom: 0,
                        child: Container(
                          width: 0.8.sw,
                          height: 0.3.sh,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 100.w,
                        vertical: 30.h,
                      ),
                      decoration: AxataTheme.styleGradientUD,
                      child: Obx(
                        () => Text(
                          'Tingkat Senyum : ${controller.tingkatSenyum}',
                          style: AxataTheme.fiveMiddle
                              .copyWith(color: AxataTheme.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 72.h),
          Obx(
            () => GestureDetector(
              onLongPress: () {},
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 144.w,
                  vertical: 30.h,
                ),
                decoration: controller.isSmiling.value
                    ? AxataTheme.styleGradientUD
                    : AxataTheme.styleRedGradientUD,
                child: Text(
                  ' ${controller.isSmiling.value ? 'Senyum' : 'Belum Senyum'}',
                  style:
                      AxataTheme.fiveMiddle.copyWith(color: AxataTheme.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 72.h),
          Obx(
            () => Text(
              controller.timerText.value == '0'
                  ? ''
                  : 'Tahan Senyum Selama ${controller.timerText.value} Detik',
              style: AxataTheme.fiveMiddle,
            ),
          )
        ],
      ),
    );
  }
}
