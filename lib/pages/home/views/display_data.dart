import 'package:axata_absensi/models/Absensi/dataabsen_model.dart';
import 'package:axata_absensi/pages/home/controllers/home_controller.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DisplayDataCheckInOut extends StatelessWidget {
  const DisplayDataCheckInOut({
    super.key,
    required this.controller,
    required this.data,
  });
  final HomeController controller;
  final DataAbsenModel data;

  @override
  Widget build(BuildContext context) {
    Color getColorCheckin() {
      return controller.isTimeBeforeJadwalCheckIn(
        DateFormat('HH:mm').format(data.jamMasuk),
      )
          ? AxataTheme.green
          : AxataTheme.red;
    }

    Color getColorCheckOut() {
      return controller.isTimeAfterJadwalCheckOut(
              DateFormat('HH:mm').format(data.jamKeluar))
          ? AxataTheme.green
          : AxataTheme.red;
    }

    String getJamKeluar() {
      if (data.jamMasuk == data.jamKeluar) {
        return '-';
      } else {
        return DateFormat('HH:mm').format(data.jamKeluar);
      }
    }

    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 15.h,
                horizontal: 45.w,
              ),
              decoration: AxataTheme.styleUnselectBoxFilter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE dd MMMM yyyy', 'id_ID')
                        .format(data.jamMasuk),
                    style: AxataTheme.fourSmall,
                  ),
                  Text(
                    'CHECK-IN',
                    style: AxataTheme.oneBold.copyWith(
                      color: getColorCheckin(),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Jam Absen',
                        style: AxataTheme.oneSmall,
                      ),
                      SizedBox(width: 18.w),
                      Container(
                        width: 170.h,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 33.w),
                        decoration: AxataTheme.styleUnselectBoxFilter,
                        child: FittedBox(
                          child: Text(
                            DateFormat('HH:mm').format(data.jamMasuk),
                            style: AxataTheme.oneSmall.copyWith(
                              color: getColorCheckin(),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 15.h,
                horizontal: 45.w,
              ),
              decoration: AxataTheme.styleUnselectBoxFilter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE dd MMMM yyyy', 'id_ID')
                        .format(data.jamKeluar),
                    style: AxataTheme.fourSmall,
                  ),
                  Text(
                    'CHECK-OUT',
                    style: AxataTheme.oneBold.copyWith(
                      color: getColorCheckOut(),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Jam Absen',
                        style: AxataTheme.oneSmall,
                      ),
                      SizedBox(width: 18.w),
                      Container(
                        width: 170.h,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 33.w),
                        decoration: AxataTheme.styleUnselectBoxFilter,
                        child: FittedBox(
                          child: Text(
                            getJamKeluar(),
                            style: AxataTheme.oneSmall.copyWith(
                              color: getColorCheckOut(),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h)
      ],
    );
  }
}
