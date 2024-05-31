import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContainerInputAbsensi extends StatelessWidget {
  const ContainerInputAbsensi({
    super.key,
    required this.title,
    this.aligment = Alignment.centerLeft,
    this.child = const SizedBox.shrink(),
    this.onTap,
    this.bgColor,
  });
  final String title;
  final Alignment aligment;
  final Widget child;
  final VoidCallback? onTap;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AxataTheme.sixSmall,
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            alignment: aligment,
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 24.h),
            width: double.infinity,
            decoration: AxataTheme.styleUnselectBoxFilter.copyWith(
              color: bgColor ?? AxataTheme.white,
            ),
            child: child,
          ),
        ),
        SizedBox(height: 24.h)
      ],
    );
  }
}
