import 'package:axata_absensi/components/custom_appbar.dart';
import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/pages/setting/controllers/setting_controller.dart';
import 'package:axata_absensi/routes/app_pages.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SmileSettingView extends StatelessWidget {
  const SmileSettingView({
    super.key,
    required this.controller,
  });
  final SettingController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Setting Senyum'),
      backgroundColor: AxataTheme.bgGrey,
      body: Obx(
        () => controller.isLoading.value
            ? const SmallLoadingPage()
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    // height: 0.4.sh,
                    margin:
                        EdgeInsets.symmetric(horizontal: 60.w, vertical: 36.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 60.w, vertical: 60.h),
                    decoration: AxataTheme.styleUnselectBoxFilter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Persentase Minimal Senyum',
                          style: AxataTheme.sixSmall,
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30.w,
                                  vertical: 24.h,
                                ),
                                decoration: AxataTheme.styleUnselectBoxFilter,
                                child: TextFormField(
                                  controller: controller.smilePercentC,
                                  keyboardType: TextInputType.number,
                                  style: AxataTheme.threeSmall,
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Masukkan Persentase Senyum',
                                    hintStyle: AxataTheme.threeSmall.copyWith(
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 24.w),
                            GestureDetector(
                              onTap: () =>
                                  Get.toNamed(Routes.SMILEFACE, arguments: {
                                'fromFeatureTry': true,
                                'smileDuration':
                                    int.parse(controller.smileDurationC.text),
                                'smilePercent':
                                    int.parse(controller.smilePercentC.text),
                              }),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30.w,
                                  vertical: 24.h,
                                ),
                                decoration: AxataTheme.styleGradientUD,
                                child: Text(
                                  'Coba Fitur',
                                  style: AxataTheme.fourSmall.copyWith(
                                    color: AxataTheme.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 48.h),
                        Text(
                          'Durasi Senyum',
                          style: AxataTheme.sixSmall,
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.w,
                            vertical: 24.h,
                          ),
                          decoration: AxataTheme.styleUnselectBoxFilter,
                          child: TextFormField(
                            controller: controller.smileDurationC,
                            keyboardType: TextInputType.number,
                            style: AxataTheme.threeSmall,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Masukkan Durasi Senyum',
                              hintStyle: AxataTheme.threeSmall.copyWith(
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 72.h),
                        GestureDetector(
                          onTap: () => controller.handleSimpan(),
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
                ],
              ),
      ),
    );
  }
}
