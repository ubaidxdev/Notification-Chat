import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors();
  Color primary = const Color(0xffF8C433);
  Color yellowlight = const Color(0xffFEDE76);
  Color green = const Color(0xff508D69);
  Color bg = const Color.fromARGB(255, 255, 255, 255);
  Color lightblue = const Color(0xffF0F6F9);
  Color black = const Color(0xff010101);
  Color white = const Color(0xffFFFFFF);
  Color graylight = const Color(0xffBEBFC1);
  Color graylight2 = const Color.fromARGB(255, 230, 231, 232);
  Color red = const Color(0xffCF0A0A);
}

class AppTextTheme {
  AppTextTheme();
  // NORMAL
  TextStyle fs10Normal =
      GoogleFonts.outfit(fontSize: 10.sp, fontWeight: FontWeight.w400);
  TextStyle fs12Normal =
      GoogleFonts.outfit(fontSize: 12.sp, fontWeight: FontWeight.w400);
  TextStyle fs14Normal =
      GoogleFonts.outfit(fontSize: 14.sp, fontWeight: FontWeight.w400);
  TextStyle fs16Normal =
      GoogleFonts.outfit(fontSize: 16.sp, fontWeight: FontWeight.w400);
  TextStyle fs18Normal =
      GoogleFonts.outfit(fontSize: 18.sp, fontWeight: FontWeight.w400);
  TextStyle fs20Normal =
      GoogleFonts.outfit(fontSize: 20.sp, fontWeight: FontWeight.w400);
  TextStyle fs24Normal =
      GoogleFonts.outfit(fontSize: 24.sp, fontWeight: FontWeight.w400);

  // MEDIUM
  TextStyle fs18Medium =
      GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w500);
  TextStyle fs20Medium =
      GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.w500);
  TextStyle fs24Medium =
      GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.w500);
  TextStyle fs35Medium =
      GoogleFonts.poppins(fontSize: 35.sp, fontWeight: FontWeight.w500);
}
