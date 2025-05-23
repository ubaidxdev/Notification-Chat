import 'dart:io';

import 'package:notification_chat/Components/Tiles/primary_container.dart';
import 'package:notification_chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickBottomsheet extends StatelessWidget {
  final String? title;
  final Function(File) file;
  const ImagePickBottomsheet({super.key, this.title, required this.file});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
          color: constantSheet.colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(Icons.keyboard_arrow_up)),
          ),
          constantSheet.services.addheight(15.h),
          Text(
            title ?? "",
            style: constantSheet.textTheme.fs16Normal,
          ),
          constantSheet.services.addheight(15.h),
          Divider(
            color: constantSheet.colors.graylight,
          ),
          constantSheet.services.addheight(15.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final imagePath = await getImageFormGallery();
                    file(File(imagePath));
                    Get.back();
                  },
                  child: PrimaryContainer(
                    color: constantSheet.colors.graylight2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(constantSheet.images.gallery),
                        constantSheet.services.addheight(10.h),
                        Text(
                          "Gallery",
                          style: constantSheet.textTheme.fs16Normal,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              constantSheet.services.addwidth(30.w),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final imagePath = await getImageFormCamera();
                    file(File(imagePath));
                    Get.back();
                  },
                  child: PrimaryContainer(
                    color: constantSheet.colors.graylight2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(constantSheet.images.camera),
                        constantSheet.services.addheight(10.h),
                        Text(
                          "Camera",
                          style: constantSheet.textTheme.fs16Normal,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Future<String> getImageFormGallery() async {
  final ImagePicker picker = ImagePicker();
  // ignore: invalid_use_of_visible_for_testing_member
  var getImage = await picker.pickImage(source: ImageSource.gallery);
  // .getImageFromSource(source: ImageSource.gallery);

  String image = '';

  if (getImage != null) {
    image = getImage.path;
  }

  return image;
}

// Get Image Camra
Future<String> getImageFormCamera() async {
  var getImage =
      // ignore: invalid_use_of_visible_for_testing_member
      await ImagePicker.platform.getImageFromSource(source: ImageSource.camera);
  String image = '';
  if (getImage != null) {
    image = getImage.path;
  }
  return image;
}
