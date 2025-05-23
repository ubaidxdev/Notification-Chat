import 'package:notification_chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final bool isExpanded;
  final bool isloading;
  final bool backGroundTransparent;
  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backGroundTransparent = false,
    this.isExpanded = false,
    this.isloading = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = TextButton(
        onPressed: () {
          isloading ? null : onPressed();
        },
        style: TextButton.styleFrom(
            // padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
            minimumSize: const Size(100, 50),
            backgroundColor: backGroundTransparent
                ? Colors.transparent
                : constantSheet.colors.primary,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: constantSheet.colors.primary),
                borderRadius: BorderRadius.circular(10.r))),
        child: isloading
            ? SizedBox(
                height: 20.sp,
                width: 20.sp,
                child: CircularProgressIndicator(
                  color: constantSheet.colors.white,
                ),
              )
            : Text(
                title,
                style: constantSheet.textTheme.fs18Medium.copyWith(
                    color: backGroundTransparent
                        ? constantSheet.colors.black
                        : constantSheet.colors.white),
              ));
    return isExpanded ? Row(children: [Expanded(child: button)]) : button;
  }
}
