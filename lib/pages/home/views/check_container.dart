import 'package:axata_absensi/pages/home/controllers/home_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CheckInOutContainer extends StatelessWidget {
  const CheckInOutContainer({
    super.key,
    required this.onTap,
    required this.controller,
    required this.isCheckIn,
    required this.timeCheck,
  });
  final VoidCallback onTap;
  final HomeController controller;
  final bool isCheckIn;
  final RxString timeCheck;

  @override
  Widget build(BuildContext context) {
    Widget beforeTimeCheck() {
      return FaIcon(
        FontAwesomeIcons.solidCheckCircle,
        color: AxataTheme.green,
      );
    }

    Widget handleCheck() {
      if (timeCheck.value == '') {
        if (controller.isLoadingCheckIn.value) {
          return SizedBox(
            width: 70.h,
            height: 70.h,
            child: const CircularProgressIndicator(),
          );
        } else {
          return GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 30.w,
                vertical: 12.h,
              ),
              decoration: isCheckIn
                  ? AxataTheme.styleGradientUD
                  : ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AxataTheme.red,
                          const Color(0xFFFE6929),
                          const Color(0xFFFE6929)
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 2,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        )
                      ],
                    ),
              child: Text(
                isCheckIn ? 'Masuk' : 'Keluar',
                style: AxataTheme.oneBold.copyWith(
                  color: AxataTheme.white,
                ),
              ),
            ),
          );
        }
      } else {
        return beforeTimeCheck();
      }
    }

    Widget handleAbsen() {
      if (timeCheck.value == '') {
        return Text(
          '------',
          style: AxataTheme.oneSmall,
        );
      } else {
        return Row(
          children: [
            FaIcon(
              FontAwesomeIcons.clock,
              color: isCheckIn ? AxataTheme.mainColor : AxataTheme.red,
              size: 40.r,
            ),
            SizedBox(width: 36.w),
            SizedBox(
              width: 120.w,
              child: Text(
                timeCheck.value,
                style: AxataTheme.oneBold,
              ),
            ),
            SizedBox(width: 36.w),
            Text(
              'WIB',
              style: AxataTheme.oneSmall,
            ),
          ],
        );
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 45.w,
        vertical: 24.h,
      ),
      decoration: AxataTheme.styleUnselectBoxFilter,
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.calendarCheck,
            size: 80.r,
            color: isCheckIn ? AxataTheme.mainColor : AxataTheme.red,
          ),
          SizedBox(
            width: 30.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCheckIn ? 'ABSEN MASUK' : 'ABSEN KELUAR',
                  style: AxataTheme.oneBold,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 240.w,
                      child: Text(
                        'Dijadwalkan',
                        style: AxataTheme.oneSmall,
                      ),
                    ),
                    FaIcon(
                      FontAwesomeIcons.clock,
                      color: isCheckIn ? AxataTheme.mainColor : AxataTheme.red,
                      size: 40.r,
                    ),
                    SizedBox(width: 36.w),
                    Obx(
                      () => SizedBox(
                        width: 120.w,
                        child: Text(
                          isCheckIn
                              ? controller.jadwalCheckIn.value
                              : controller.jadwalCheckOut.value,
                          style: AxataTheme.oneBold,
                        ),
                      ),
                    ),
                    SizedBox(width: 36.w),
                    Text(
                      'WIB',
                      style: AxataTheme.oneSmall,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 240.w,
                      child: Text(
                        'Jam Absen',
                        style: AxataTheme.oneSmall,
                      ),
                    ),
                    Obx(
                      () => handleAbsen(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 30.w,
          ),
          Obx(
            () => handleCheck(),
          ),
        ],
      ),
    );
  }
}
