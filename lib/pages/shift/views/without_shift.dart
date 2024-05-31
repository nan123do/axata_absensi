import 'package:axata_absensi/components/small_loading.dart';
import 'package:axata_absensi/pages/shift/controllers/shift_controller.dart';
import 'package:axata_absensi/pages/shift/views/checkbox_shift.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WithoutShiftView extends StatelessWidget {
  const WithoutShiftView({
    super.key,
    required this.controller,
  });

  final ShiftController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        Expanded(
          child: Obx(
            () => controller.isLoading.value
                ? const SmallLoadingPage()
                : ListView.builder(
                    itemCount: controller.listShift.length,
                    itemBuilder: (context, index) {
                      return CheckBoxShift(
                        listShift: controller.listShift,
                        controller: controller,
                        shift: controller.listShift[index],
                      );
                    },
                  ),
          ),
        ),
        SizedBox(height: 50.h),
        GestureDetector(
          onTap: () =>
              controller.simpan(type: 'default', data: controller.listShift),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 360.w,
              vertical: 30.h,
            ),
            decoration: AxataTheme.styleGradientUD,
            child: Text(
              'Simpan',
              style: AxataTheme.fiveMiddle.copyWith(
                color: AxataTheme.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 50.h)
      ],
    );
  }
}
