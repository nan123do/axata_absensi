// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AxataTheme {
  //Screen Util Init
  static double screenHeight = 2340;
  static double screenWidth = 1080;

  // Color
  static Color bgGrey = Color(0xffF5F5F5);
  static Color mainColor = Color(0xff11a9fd);
  static Color white = Colors.white;
  static Color black = Color(0xff2c2c2c);
  static Color grey = Color(0xff3E3E3E);
  static Color red = Color(0xffFF0202);
  static Color green = Color(0xff36BB43);

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
}
