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
    String getJadwalAbsen(
      String filter,
    ) {
      String hasil = '-';
      if (data.jamKerja != '') {
        List<String> jadwal = data.jamKerja.split('-');
        if (filter == 'checkin') {
          hasil = jadwal[0];
        } else {
          hasil = jadwal[1];
        }
      }
      return hasil;
    }

    Color getColorCheckin() {
      String jadwal = getJadwalAbsen('checkin');
      return controller.isTimeBeforeJadwalCheckIn(
        DateFormat('HH:mm').format(data.jamMasuk),
        jadwal,
      )
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

    Expanded subTitleRowLeft(String title) {
      return Expanded(
        child: Text(
          title,
          style: AxataTheme.oneSmall,
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 15.h,
                  horizontal: 40.w,
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
                      'ABSEN MASUK',
                      style: AxataTheme.oneBold.copyWith(
                        color: getColorCheckin(),
                      ),
                    ),
                    Row(
                      children: [
                        subTitleRowLeft('Jadwal'),
                        SizedBox(width: 18.w),
                        Container(
                          width: 170.h,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 33.w),
                          decoration: AxataTheme.styleUnselectBoxFilter,
                          child: FittedBox(
                            child: Text(
                              getJadwalAbsen('checkin'),
                              style: AxataTheme.oneSmall.copyWith(
                                color: getColorCheckin(),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Row(
                      children: [
                        subTitleRowLeft('Jam Absen'),
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
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 15.h,
                  horizontal: 40.w,
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
                      'ABSEN KELUAR',
                      style: AxataTheme.oneBold.copyWith(
                        color: AxataTheme.mainColor,
                      ),
                    ),
                    Row(
                      children: [
                        subTitleRowLeft('Jadwal'),
                        SizedBox(width: 18.w),
                        Container(
                          width: 170.h,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 33.w),
                          decoration: AxataTheme.styleUnselectBoxFilter,
                          child: FittedBox(
                            child: Text(
                              getJadwalAbsen('checkout'),
                              style: AxataTheme.oneSmall.copyWith(
                                color: AxataTheme.mainColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Row(
                      children: [
                        subTitleRowLeft('Jam Absen'),
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
                                color: AxataTheme.mainColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h)
      ],
    );
  }
}
