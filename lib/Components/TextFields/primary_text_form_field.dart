import 'package:notification_chat/Utils/app_validators.dart';
import 'package:notification_chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryTextFormField extends StatelessWidget {
  final String? hinttext;
  final IconData? suffixicon;
  final Color? titleColor;
  final Color? hinttextColor;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardtype;
  final Function(String)? fieldSubmitted;
  final AppValidator? validator;
  final bool obscureText;
  final bool isDense;
  final bool readOnly;
  final Function? onTap;
  final Function? suffixiconOnTap;
  const PrimaryTextFormField({
    super.key,
    this.titleColor,
    this.hinttext,
    this.hinttextColor,
    this.controller,
    this.focusNode,
    this.fieldSubmitted,
    this.keyboardtype,
    this.validator,
    this.suffixicon,
    this.obscureText = false,
    this.isDense = true,
    this.readOnly = false,
    this.onTap,
    this.suffixiconOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        onTap != null ? onTap!() : null;
      },
      controller: controller,
      focusNode: focusNode,
      onFieldSubmitted:
          fieldSubmitted != null ? (value) => fieldSubmitted!(value) : null,
      keyboardType: keyboardtype,
      validator: validator == null ? null : (v) => validator!.validator(v),
      style: constantSheet.textTheme.fs16Normal,
      obscureText: obscureText,
      readOnly: readOnly,
      decoration: InputDecoration(
        errorStyle: constantSheet.textTheme.fs14Normal
            .copyWith(color: constantSheet.colors.red),
        // isDense: isDense,
        filled: true,
        fillColor: constantSheet.colors.lightblue,
        hintText: hinttext,
        hintStyle: constantSheet.textTheme.fs16Normal
            .copyWith(color: hinttextColor ?? constantSheet.colors.graylight),
        suffixIcon: suffixicon != null
            ? GestureDetector(
                onTap: () {
                  suffixiconOnTap != null ? suffixiconOnTap!() : null;
                },
                child: SizedBox(
                  height: 20.sp,
                  width: 20.sp,
                  child: Center(
                    child: Icon(
                      suffixicon,
                      color: constantSheet.colors.graylight,
                    ),
                  ),
                ),
              )
            : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.r),
            borderSide: BorderSide.none),
      ),
    );
  }
}
