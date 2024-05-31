import 'package:axata_absensi/models/Shift/datashift_model.dart';
import 'package:axata_absensi/pages/shift/controllers/shift_controller.dart';
import 'package:axata_absensi/utils/datehelper.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckBoxShift extends StatelessWidget {
  const CheckBoxShift({
    super.key,
    required this.controller,
    required this.shift,
    required this.listShift,
  });

  final ShiftController controller;
  final DataShiftModel shift;
  final List<DataShiftModel> listShift;

  @override
  Widget build(BuildContext context) {
    BoxDecoration readOnlyDecoration() {
      return BoxDecoration(
        color: const Color(0xffD9D9D9),
        borderRadius: BorderRadius.all(
          Radius.circular(24.r),
        ),
      );
    }

    return Row(
      children: [
        SizedBox(width: 20.w),
        Checkbox(
          value: shift.statusAktif,
          onChanged: (bool? value) {
            controller.updateShiftStatusItem(shift, value ?? false);
          },
        ),
        Container(
          height: 100.h,
          width: 0.24.sw,
          padding: EdgeInsets.symmetric(horizontal: 66.w, vertical: 24.h),
          decoration: shift.statusAktif
              ? AxataTheme.styleUnselectBoxFilter
              : readOnlyDecoration(),
          child: Text(
            shift.hari,
            style: AxataTheme.oneSmall,
          ),
        ),
        SizedBox(width: 24.w),
        Expanded(
          child: GestureDetector(
            onTap: () => shift.statusAktif
                ? controller.changeTime(context, shift, true, listShift)
                : () {},
            child: Container(
              height: 100.h,
              padding: EdgeInsets.symmetric(
                horizontal: 66.w,
              ),
              decoration: shift.statusAktif
                  ? AxataTheme.styleUnselectBoxFilter
                  : readOnlyDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Masuk',
                    style: AxataTheme.sixSmall,
                  ),
                  Text(
                    DateHelper.strHMStoHM(shift.jamMasuk),
                    style: AxataTheme.oneBold.copyWith(
                      color: AxataTheme.mainColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => shift.statusAktif
                ? controller.changeTime(context, shift, false, listShift)
                : () {},
            child: Container(
              height: 100.h,
              padding: EdgeInsets.symmetric(
                horizontal: 66.w,
              ),
              decoration: shift.statusAktif
                  ? AxataTheme.styleUnselectBoxFilter
                  : readOnlyDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Keluar',
                    style: AxataTheme.sixSmall,
                  ),
                  Text(
                    DateHelper.strHMStoHM(shift.jamKeluar),
                    style: AxataTheme.oneBold.copyWith(
                      color: AxataTheme.mainColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 60.w),
      ],
    );
  }
}
