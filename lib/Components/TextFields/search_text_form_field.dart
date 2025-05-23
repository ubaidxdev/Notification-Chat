import 'package:notification_chat/Utils/app_validators.dart';
import 'package:notification_chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTextFormField extends StatelessWidget {
  final String? hinttext;
  final Function iconOnTap;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final Function(String)? fieldSubmitted;
  final AppValidator? validator;
  final TextInputType? keyboardtype;
  const SearchTextFormField({
    super.key,
    required this.controller,
    required this.iconOnTap,
    this.hinttext,
    this.fieldSubmitted,
    this.validator,
    this.keyboardtype,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardtype,
            focusNode: focusNode,
            onFieldSubmitted: (value) {
              iconOnTap();
            },
            validator:
                validator == null ? null : (v) => validator!.validator(v),
            decoration: InputDecoration(
              constraints: BoxConstraints(maxHeight: 50.sp, minHeight: 40.sp),
              isDense: true,
              errorStyle: constantSheet.textTheme.fs14Normal
                  .copyWith(color: constantSheet.colors.red),
              filled: true,
              fillColor: constantSheet.colors.white,
              hintText: hinttext,
              hintStyle: constantSheet.textTheme.fs16Normal
                  .copyWith(color: constantSheet.colors.graylight),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
        constantSheet.services.addwidth(10.w),
        GestureDetector(
          onTap: () {
            iconOnTap();
          },
          child: Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
                color: constantSheet.colors.primary,
                borderRadius: BorderRadius.circular(5.r)),
            child: Icon(
              Icons.search,
              size: 25.sp,
              color: constantSheet.colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
