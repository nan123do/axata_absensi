import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/pages/shift/controllers/shift_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class WithShiftView extends StatelessWidget {
  const WithShiftView({
    super.key,
    required this.controller,
  });

  final ShiftController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.h),
        Row(
          children: [
            SizedBox(width: 60.w),
            GestureDetector(
              onTap: () => controller.openModalFilterJenis(context),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 40.w,
                  vertical: 20.h,
                ),
                decoration: AxataTheme.styleUnselectBoxFilter,
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.filter,
                      color: AxataTheme.mainColor,
                      size: 30.r,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      'Filter',
                      style: AxataTheme.oneSmall.copyWith(
                        color: AxataTheme.mainColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Obx(
          () => Row(
            children: [
              SizedBox(width: 60.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.updateShiftStatus(
                    !(controller.isActiveShift.value),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    decoration: controller.isActiveShift.value
                        ? AxataTheme.styleUnselectBoxFilter
                        : AxataTheme.styleGradient,
                    alignment: Alignment.center,
                    child: Text(
                      'Tanpa Shift',
                      style: AxataTheme.sixSmall.copyWith(
                        color: controller.isActiveShift.value
                            ? AxataTheme.black
                            : AxataTheme.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.updateShiftStatus(
                    !(controller.isActiveShift.value),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    decoration: controller.isActiveShift.value
                        ? AxataTheme.styleGradient
                        : AxataTheme.styleUnselectBoxFilter,
                    alignment: Alignment.center,
                    child: Text(
                      'Shift',
                      style: AxataTheme.sixSmall.copyWith(
                        color: controller.isActiveShift.value
                            ? AxataTheme.white
                            : AxataTheme.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 60.w),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: Obx(
            () => controller.isLoading.value
                ? const SmallLoadingPage()
                : ListView.builder(
                    itemCount: controller.listNamaShift.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () => controller.goDialogShift(
                          controller.listNamaShift[index]['id'],
                          controller.listNamaShift[index]['nama'],
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 60.w,
                            vertical: 48.h,
                          ),
                          margin: EdgeInsets.only(bottom: 12.h),
                          decoration: AxataTheme.styleUnselectBoxFilter,
                          child: Text(
                            controller.listNamaShift[index]['nama'],
                            style: AxataTheme.fiveMiddle,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
        SizedBox(height: 50.h)
      ],
    );
  }
}
