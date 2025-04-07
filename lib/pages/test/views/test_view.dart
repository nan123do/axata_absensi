import 'package:axata_absensi/pages/test/controllers/test_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  final TestController controller = Get.find<TestController>();

  @override
  void initState() {
    super.initState();
    //Start showcase view after current widget frames are drawn.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context).startShowCase(
        [controller.usernameKey, controller.passwordKey],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Showcase(
                key: controller.usernameKey,
                targetPadding: EdgeInsets.all(30.r),
                tooltipBackgroundColor: AxataTheme.mainColor,
                textColor: AxataTheme.black,
                title: 'JUDUL',
                description: "Masukkan Username Anda di sini",
                child: usernameWidget(),
              ),
              SizedBox(height: 12.h),
              Showcase(
                key: controller.passwordKey,
                targetPadding: EdgeInsets.all(20.r),
                tooltipBackgroundColor: AxataTheme.mainColor,
                textColor: AxataTheme.black,
                description: "Masukkan Password Anda di sini",
                child: passwordWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
