import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/pages/profile/controllers/profile_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({
    super.key,
    required this.controller,
  });
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    Widget titleField(String text, bool required) {
      return Column(
        children: [
          RichText(
            text: TextSpan(
              text: text,
              style: AxataTheme.sixSmall,
              children: required
                  ? [
                      TextSpan(
                        text: ' *',
                        style: AxataTheme.sixSmall.copyWith(color: Colors.red),
                      ),
                    ]
                  : [],
            ),
          ),
          AxataTheme.styleJarak12,
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Ubah Password'),
      backgroundColor: AxataTheme.bgGrey,
      body: Obx(
        () => controller.isLoading.value
            ? const SmallLoadingPage()
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 36.h),
                color: AxataTheme.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),
                    titleField('Password Lama', true),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.w,
                        vertical: 24.h,
                      ),
                      decoration: AxataTheme.styleUnselectBoxFilter,
                      child: Row(
                        children: [
                          Obx(
                            () => Expanded(
                              child: TextFormField(
                                controller: controller.oldPasswordC,
                                keyboardType: TextInputType.text,
                                style: AxataTheme.threeSmall,
                                obscureText:
                                    controller.isObsecureOldPassword.value,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Masukkan Password Lama',
                                  hintStyle: AxataTheme.threeSmall.copyWith(
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                controller.isObsecureOldPassword.value =
                                    !(controller.isObsecureOldPassword.value);
                              },
                              child: FaIcon(
                                controller.isObsecureOldPassword.value
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 50.r,
                                color: AxataTheme.mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AxataTheme.styleJarak12,
                    titleField('Password Baru', true),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.w,
                        vertical: 24.h,
                      ),
                      decoration: AxataTheme.styleUnselectBoxFilter,
                      child: Row(
                        children: [
                          Obx(
                            () => Expanded(
                              child: TextFormField(
                                controller: controller.passwordC,
                                keyboardType: TextInputType.text,
                                style: AxataTheme.threeSmall,
                                obscureText:
                                    controller.isObsecurePassword.value,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Masukkan Password Baru',
                                  hintStyle: AxataTheme.threeSmall.copyWith(
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                controller.isObsecurePassword.value =
                                    !(controller.isObsecurePassword.value);
                              },
                              child: FaIcon(
                                controller.isObsecurePassword.value
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 50.r,
                                color: AxataTheme.mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AxataTheme.styleJarak12,
                    titleField('Konfirmasi Password', true),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.w,
                        vertical: 24.h,
                      ),
                      decoration: AxataTheme.styleUnselectBoxFilter,
                      child: Row(
                        children: [
                          Obx(
                            () => Expanded(
                              child: TextFormField(
                                controller: controller.passwordKC,
                                keyboardType: TextInputType.text,
                                style: AxataTheme.threeSmall,
                                obscureText:
                                    controller.isObsecurePasswordK.value,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Masukkan Konfirmasi Password',
                                  hintStyle: AxataTheme.threeSmall.copyWith(
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                controller.isObsecurePasswordK.value =
                                    !(controller.isObsecurePasswordK.value);
                              },
                              child: FaIcon(
                                controller.isObsecurePasswordK.value
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 50.r,
                                color: AxataTheme.mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(height: 72.h),
                    GestureDetector(
                      onTap: () => controller.handleUbahPassword(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 30.h,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 60.w),
                        alignment: Alignment.center,
                        decoration: AxataTheme.styleGradientUD,
                        child: Text(
                          'Simpan',
                          style: AxataTheme.fiveMiddle.copyWith(
                            color: AxataTheme.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
