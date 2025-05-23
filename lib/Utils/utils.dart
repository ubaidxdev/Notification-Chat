import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../main.dart';

class AppUtils {
  // ------ Focus Change--------
  // --------
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static messageSnakeBar(String title, String message) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.TOP,
        borderRadius: 20.r,
        duration: const Duration(seconds: 4),
        colorText: constantSheet.colors.black,
        backgroundColor: constantSheet.colors.white);
  }
}
