import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notification_chat/main.dart';


class ImageSendScreen extends StatelessWidget {
  final File file;
  final Function ontap;
  const ImageSendScreen({super.key, required this.file, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantSheet.colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Center(
            child: Image.file(
              file,
              height: constantSheet.services.screenHeight(context) * 0.8,
              width: constantSheet.services.screenWidth(context),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                ontap();
              },
              child: Container(
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                    color: constantSheet.colors.primary,
                    shape: BoxShape.circle),
                child: Icon(
                  Icons.send,
                  size: 30.sp,
                  color: constantSheet.colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
