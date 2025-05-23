import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:notification_chat/Components/Bottom%20Sheets/image_pick_bottomsheet.dart';
import 'package:notification_chat/Components/Buttons/primary_button.dart';
import 'package:notification_chat/Components/TextFields/primary_text_form_field.dart';
import 'package:notification_chat/Controllers/user_controller.dart';
import 'package:notification_chat/Data/Functions/cloudinary_functions.dart';
import 'package:notification_chat/Models/user_model.dart';
import 'package:notification_chat/Utils/app_validators.dart';
import 'package:notification_chat/Utils/utils.dart';
import 'package:notification_chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final userController = Get.find<UserController>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  String userImageUrl = "";
  File? imagefile;
  @override
  void initState() {
    super.initState();
    setdata();
  }

  setdata() {
    userImageUrl = userController.userdata.profileImage ?? "";
    _nameController.text = userController.userdata.name ?? "";
    _emailController.text = userController.userdata.email ?? "";
    _userNameController.text = userController.userdata.userName ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0.sp),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Stack(children: [
                  Container(
                    height: 100.sp,
                    width: 100.sp,
                    decoration: BoxDecoration(
                        border: Border.all(color: constantSheet.colors.primary),
                        shape: BoxShape.circle),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: imagefile == null
                          ? (userImageUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: userImageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: SizedBox(
                                        height: 12.sp,
                                        width: 12.sp,
                                        child: CircularProgressIndicator(
                                          color: constantSheet.colors.white,
                                          strokeWidth: 3,
                                        )),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(child: Icon(Icons.error)),
                                )
                              : Image.asset(
                                  constantSheet.images.user,
                                  fit: BoxFit.cover,
                                ))
                          : Image.file(
                              imagefile!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: -6,
                    child: GestureDetector(
                      onTap: () async {
                        await Get.bottomSheet(ImagePickBottomsheet(
                          title: "Profile Image",
                          file: (file) {
                            if (file.path.isNotEmpty) {
                              setState(() {
                                imagefile = file;
                              });
                            }
                          },
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.sp),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: constantSheet.colors.white,
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  )
                ]),
              ),
              Gap(50.h),
              PrimaryTextFormField(
                controller: _nameController,
                hinttext: "Name",
                validator: TextValidator(),
              ),
              Gap(10.h),
              PrimaryTextFormField(
                controller: _userNameController,
                hinttext: "User Name",
                validator: TextValidator(),
              ),
              Gap(10.h),
              PrimaryTextFormField(
                controller: _emailController,
                hinttext: "Email",
                readOnly: true,
                validator: EmailValidator(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(15.sp),
        child: GetBuilder<UserController>(
          builder: (controller) {
            return PrimaryButton(
              title: "Save",
              onPressed: () async {
                String url = "";
                if (imagefile != null && imagefile!.path.isNotEmpty) {
                  url = await CloudinaryFunctions()
                      .uploadImageToCloudinary(imagefile!);
                } else {
                  url = userImageUrl;
                }
                final db = UserModel(
                  id: controller.userdata.id,
                  name: _nameController.text,
                  userName: _userNameController.text.trim(),
                  email: _emailController.text,
                  profileImage: url,
                  chatRoomIds: controller.userdata.chatRoomIds,
                  inactiveTime: controller.userdata.inactiveTime,
                  status: controller.userdata.status,
                );
                String chakeUserName = "";
                if (_userNameController.text != controller.userdata.userName) {
                  chakeUserName = await controller
                      .searchuser(_userNameController.text.trim());
                }
                if (chakeUserName.isEmpty) {
                  await controller.updateUserData(db);
                  Get.back();
                } else {
                  AppUtils.messageSnakeBar("Please",
                      "change UserName beacuse this UserName is alreday used");
                }
                Get.back();
              },
              isloading: userController.loading,
              isExpanded: true,
            );
          },
        ),
      ),
    );
  }
}
