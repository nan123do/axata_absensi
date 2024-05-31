import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DatePickV2 extends StatelessWidget {
  const DatePickV2({
    Key? key,
    required this.dateFromText,
    required this.dateToText,
    required this.funcDateFrom,
    required this.funcDateTo,
  }) : super(key: key);

  final String dateFromText;
  final String dateToText;
  final Function funcDateFrom;
  final Function funcDateTo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 0.5.sw,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tanggal Awal',
                style: AxataTheme.oneSmall,
              ),
              GestureDetector(
                onTap: () => funcDateFrom(),
                child: FittedBox(
                  child: Text(
                    dateFromText,
                    style: AxataTheme.fiveMiddle
                        .copyWith(color: AxataTheme.mainColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tanggal Akhir',
              style: AxataTheme.oneSmall,
            ),
            GestureDetector(
              onTap: () => funcDateTo(),
              child: FittedBox(
                child: Text(
                  dateToText,
                  style: AxataTheme.fiveMiddle
                      .copyWith(color: AxataTheme.mainColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
