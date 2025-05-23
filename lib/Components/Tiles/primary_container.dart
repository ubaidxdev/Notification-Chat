
import 'package:notification_chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  final double? height;
  final double? width;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  const PrimaryContainer({
    super.key,
    required this.child,
    this.borderRadius,
    this.height,
    this.width,
    this.color,
    this.padding,
    this.margin,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      height: height,
      width: width ?? constantSheet.services.screenWidth(context),
      padding: padding ?? EdgeInsets.all(10.sp),
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? constantSheet.colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
      ),
      child: child,
    );
  }
}
