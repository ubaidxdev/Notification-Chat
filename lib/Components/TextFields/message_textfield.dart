import 'package:notification_chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class MessageTextfield extends StatefulWidget {
  final Function onFieldSubmitted;
  final Function cameraOntap;
  final TextEditingController controller;
  const MessageTextfield(
      {super.key, required this.onFieldSubmitted, required this.controller,required this.cameraOntap});

  @override
  State<MessageTextfield> createState() => _MessageTextfieldState();
}

class _MessageTextfieldState extends State<MessageTextfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.sp)
          .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        width: constantSheet.services.screenWidth(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                    color: constantSheet.colors.graylight2,
                    border: Border.all(color: constantSheet.colors.black),
                    borderRadius: BorderRadius.circular(100.r)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                     widget. cameraOntap();
                      },
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 30.sp,
                        color: constantSheet.colors.black,
                      ),
                    ),
                    Gap(5.w),
                    Expanded(
                      child: TextFormField(
                        controller: widget.controller,
                        onFieldSubmitted: (value) {
                          widget.onFieldSubmitted();
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Messages...."),
                      ),
                    ),
                    Gap(10.w),
                    GestureDetector(
                      onTap: () {
                        widget.onFieldSubmitted();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.h),
                        decoration: BoxDecoration(
                            color: constantSheet.colors.primary,
                            borderRadius: BorderRadius.circular(20.r)),
                        child: Icon(
                          Icons.send,
                          size: 30.sp,
                          color: constantSheet.colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ).paddingOnly(bottom: 10.h),
    );
  }
}
