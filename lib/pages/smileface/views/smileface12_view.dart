import 'dart:io';

import 'package:axata_absensi/pages/smileface/controllers/smileface_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:axata_absensi/utils/theme.dart';

class SmileFaceAndroid12View extends StatelessWidget {
  const SmileFaceAndroid12View({
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
          SizedBox(height: 24.h),
          controller.imageFile == null
              ? Container(
                  width: 300,
                  height: 300,
                  color: Colors.grey[400],
                  child: const Center(
                    child: Text("Ambil gambar dari kamera"),
                  ),
                )
              : Image.file(
                  File(controller.imageFile!.path),
                  width: 350,
                  height: 450,
                  fit: BoxFit.contain,
                ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: () => controller.handlePickCamera(),
            child: Container(
              width: 0.5.sw,
              padding: EdgeInsets.symmetric(
                horizontal: 144.w,
                vertical: 30.h,
              ),
              decoration: AxataTheme.styleGradientUD,
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.camera,
                    size: 50.r,
                    color: AxataTheme.white,
                  ),
                  SizedBox(width: 24.w),
                  Text(
                    'Kamera',
                    style: AxataTheme.oneBold.copyWith(color: AxataTheme.white),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 144.w,
              vertical: 30.h,
            ),
            decoration: controller.isSmiling.value
                ? AxataTheme.styleGradientUD
                : AxataTheme.styleRedGradientUD,
            child: Obx(
              () => Text(
                ' ${controller.isSmiling.value ? 'Senyum' : 'Belum Senyum'} ${controller.tingkatSenyum.value}',
                style: AxataTheme.fiveMiddle.copyWith(color: AxataTheme.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
