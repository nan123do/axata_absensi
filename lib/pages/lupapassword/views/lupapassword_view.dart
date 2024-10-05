import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/pages/lupapassword/controllers/lupapassword_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LupaPasswordView extends GetView<LupaPasswordController> {
  const LupaPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Lupa password'),
      backgroundColor: AxataTheme.bgGrey,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 36.h),
        color: AxataTheme.white,
        child: Column(
          children: [
            Text(
              'Silakan masukkan alamat email yang terdaftar untuk mereset kata sandi Anda.',
              style: AxataTheme.threeSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 36.h),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 30.w,
                vertical: 24.h,
              ),
              decoration: AxataTheme.styleUnselectBoxFilter,
              child: TextFormField(
                controller: controller.emailC,
                keyboardType: TextInputType.emailAddress,
                style: AxataTheme.threeSmall,
                decoration: InputDecoration.collapsed(
                  hintText: 'user123@gmail.com',
                  hintStyle: AxataTheme.threeSmall.copyWith(
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Obx(
              () => GestureDetector(
                onTap: () {
                  if (controller.isLoading.isFalse) {
                    controller.handleSimpan();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 30.h,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 60.w),
                  alignment: Alignment.center,
                  decoration: AxataTheme.styleGradientUD,
                  child: Text(
                    controller.isLoading.isFalse
                        ? 'Reset Kata Sandi'
                        : 'Loading..',
                    style: AxataTheme.fiveMiddle.copyWith(
                      color: AxataTheme.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
