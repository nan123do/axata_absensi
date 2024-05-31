import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContainerTotalAbsensi extends StatelessWidget {
  const ContainerTotalAbsensi({
    super.key,
    required this.title,
    required this.nilai,
    required this.color,
  });
  final String title;
  final String nilai;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 30.w,
        ),
        decoration: BoxDecoration(
          color: AxataTheme.white,
          borderRadius: BorderRadius.all(
            Radius.circular(24.r),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 2,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: AxataTheme.fourSmall,
            ),
            Text(
              nilai,
              style: AxataTheme.oneBold,
            ),
          ],
        ),
      ),
    );
  }
}
