// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AxataTheme {
  //Screen Util Init
  static double screenHeight = 2340;
  static double screenWidth = 1080;
  static var currency = NumberFormat("#,##0", "en_US");

  // Color
  static Color bgGrey = Color(0xffF5F5F5);
  static Color mainColor = Color(0xff11a9fd);
  static Color white = Colors.white;
  static Color black = Color(0xff2c2c2c);
  static Color grey = Color(0xff3E3E3E);
  static Color red = Color(0xffFF0202);
  static Color green = Color(0xff36BB43);
  static Color yellow = Color(0xffFEF529);

  static TextStyle oneBold = GoogleFonts.poppins(
    fontSize: 36.sp,
    fontWeight: FontWeight.w600,
    color: black,
  );

  static TextStyle oneSmall = GoogleFonts.poppins(
    fontSize: 36.sp,
    fontWeight: FontWeight.w400,
    color: grey,
  );

  static TextStyle twoBold = GoogleFonts.poppins(
    fontSize: 60.sp,
    fontWeight: FontWeight.w500,
    color: black,
  );

  static TextStyle threeSmall = GoogleFonts.poppins(
    fontSize: 42.sp,
    fontWeight: FontWeight.w400,
    color: grey,
  );

  static TextStyle fourSmall = GoogleFonts.poppins(
    fontSize: 30.sp,
    fontWeight: FontWeight.w400,
    color: grey,
  );

  static TextStyle fiveMiddle = GoogleFonts.poppins(
    fontSize: 42.sp,
    fontWeight: FontWeight.w600,
    color: black,
  );

  static TextStyle sixSmall = GoogleFonts.poppins(
    fontSize: 30.sp,
    fontWeight: FontWeight.w300,
    color: grey,
  );

  static TextStyle sevenSmall = GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeight.w300,
    color: mainColor,
  );

  // Box Decoration
  static ShapeDecoration styleGradient = ShapeDecoration(
    gradient: const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF0276FF), Color(0xFF11A9FD), Color(0xFF11A9FD)],
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    shadows: const [
      BoxShadow(
        color: Color(0x3F000000),
        blurRadius: 2,
        offset: Offset(0, 0),
        spreadRadius: 0,
      )
    ],
  );

  static ShapeDecoration styleRedGradient = ShapeDecoration(
    gradient: const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFFFF0202), Color(0xFFFE6929), Color(0xFFFE6929)],
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    shadows: const [
      BoxShadow(
        color: Color(0x3F000000),
        blurRadius: 2,
        offset: Offset(0, 0),
        spreadRadius: 0,
      )
    ],
  );

  static ShapeDecoration styleGradientUD = ShapeDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF0276FF), Color(0xFF11A9FD), Color(0xFF11A9FD)],
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    shadows: const [
      BoxShadow(
        color: Color(0x3F000000),
        blurRadius: 2,
        offset: Offset(0, 0),
        spreadRadius: 0,
      )
    ],
  );

  static ShapeDecoration styleRedGradientUD = ShapeDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFF0202), Color(0xFFFE6929), Color(0xFFFE6929)],
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    shadows: const [
      BoxShadow(
        color: Color(0x3F000000),
        blurRadius: 2,
        offset: Offset(0, 0),
        spreadRadius: 0,
      )
    ],
  );

  static BoxDecoration styleUnselectBoxFilter = BoxDecoration(
    color: white,
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
  );

  static SizedBox styleJarak12 = SizedBox(
    height: 12.h,
  );

  static BoxDecoration styleBoxFilter = BoxDecoration(
    color: mainColor.withOpacity(0.1),
    border: Border.all(color: mainColor),
    borderRadius: BorderRadius.all(
      Radius.circular(24.r),
    ),
  );
}
