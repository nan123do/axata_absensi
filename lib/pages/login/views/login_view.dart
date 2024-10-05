import 'package:axata_absensi/pages/login/controllers/login_controller.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/utils/global_data.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    Container buttonCloudId() {
      return Container(
        margin: EdgeInsets.only(
          top: 0.01.sh,
        ),
        width: 0.8.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center(
            //   child: Text(
            //     'Cloud Id',
            //     style: AxataTheme.threeSmall,
            //   ),
            // ),
            // SizedBox(
            //   height: 20.h,
            // ),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.IDCLOUD),
              child: Obx(
                () => Container(
                  height: 140.h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: AxataTheme.mainColor,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.textIdCloud.value,
                        style: AxataTheme.oneSmall,
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                        ),
                        decoration: BoxDecoration(
                          color: AxataTheme.white,
                          border: Border.all(
                            color: AxataTheme.mainColor,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          controller.textKoneksi.value,
                          style: AxataTheme.sevenSmall,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        '| ${controller.textKeterangan.value}',
                        style: AxataTheme.oneSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Column usernameWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Username',
            style: AxataTheme.threeSmall,
          ),
          SizedBox(
            height: 20.h,
          ),
          Container(
            height: 140.h,
            width: 0.8.sw,
            padding: EdgeInsets.symmetric(
              horizontal: 40.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: AxataTheme.mainColor,
              ),
            ),
            child: Center(
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.userAlt,
                    color: AxataTheme.mainColor,
                    size: 45.r,
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: controller.usernameC,
                      style: TextStyle(
                        color: AxataTheme.black,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Username kamu',
                        hintStyle: AxataTheme.oneSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Column passwordWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password',
            style: AxataTheme.threeSmall,
          ),
          SizedBox(
            height: 20.h,
          ),
          Container(
            height: 140.h,
            width: 0.8.sw,
            padding: EdgeInsets.symmetric(
              horizontal: 40.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: AxataTheme.mainColor,
              ),
            ),
            child: Center(
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.lock,
                    color: AxataTheme.mainColor,
                    size: 45.r,
                  ),
                  SizedBox(width: 40.w),
                  Obx(
                    () => Expanded(
                      child: TextFormField(
                        controller: controller.passC,
                        style: TextStyle(
                          color: AxataTheme.black,
                        ),
                        obscureText: controller.isObsecure.value,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Password kamu',
                          hintStyle: AxataTheme.oneSmall,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => IconButton(
                      onPressed: () {
                        controller.isObsecure.value =
                            !(controller.isObsecure.value);
                      },
                      icon: FaIcon(
                        controller.isObsecure.value
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
          ),
        ],
      );
    }

    Widget lupaPasswordWidget() {
      if (GlobalData.isKoneksiOnline()) {
        if (GlobalData.tipeLogin == 'karyawan') {
          return Center(
            child: Text(
              'Lupa Password?  hubungi Admin perusahaan',
              style: AxataTheme.oneSmall,
            ),
          );
        } else {
          return GestureDetector(
            onTap: () => Get.toNamed(Routes.LUPAPASSWORD),
            child: Center(
              child: Text(
                'Lupa Password?',
                style:
                    AxataTheme.oneSmall.copyWith(color: AxataTheme.mainColor),
              ),
            ),
          );
        }
      }

      return Container();
    }

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: AxataTheme.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/bg_login.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 120.h,
            child: Image.asset(
              'assets/logo/absensi_white.png',
              height: 170.h,
            ),
          ),
          Positioned(
            top: 160.h,
            left: 80.h,
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.WELCOME),
              child: FaIcon(
                FontAwesomeIcons.angleLeft,
                size: 80.r,
                color: AxataTheme.white,
              ),
            ),
          ),
          Positioned(
            top: 0.07.sh,
            child: Image.asset(
              'assets/image/vector_login.png',
              height: 0.48.sh,
            ),
          ),
          Positioned(
            bottom: GlobalData.isKoneksiOnline() ? 100 : 0,
            child: Container(
              width: 1.sw,
              padding: EdgeInsets.only(top: 40.h, left: 100.w, right: 100.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AxataTheme.white,
                borderRadius: BorderRadius.circular(80.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login',
                    style: AxataTheme.twoBold.copyWith(
                      color: AxataTheme.mainColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Visibility(
                    visible: !GlobalData.isKoneksiOnline(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buttonCloudId(),
                        SizedBox(height: 60.h),
                      ],
                    ),
                  ),
                  usernameWidget(),
                  SizedBox(height: 12.h),
                  passwordWidget(),
                  Obx(
                    () => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          activeColor: AxataTheme.mainColor,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: controller.saveCredential.value,
                          onChanged: (value) {
                            controller.saveCredential.value =
                                !(controller.saveCredential.value);
                          },
                        ),
                        Text(
                          'Simpan Info Login',
                          style: AxataTheme.oneSmall,
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => GestureDetector(
                      onTap: () => controller.login(),
                      child: Container(
                        height: 120.h,
                        width: 0.8.sw,
                        margin: EdgeInsets.only(top: 20.h),
                        decoration: AxataTheme.styleGradient,
                        alignment: Alignment.center,
                        child: Text(
                          controller.isLoading.value ? 'Loading...' : 'Login',
                          style: TextStyle(
                            fontSize: 43.sp,
                            color: AxataTheme.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  lupaPasswordWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
