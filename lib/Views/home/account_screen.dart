import 'package:cached_network_image/cached_network_image.dart';
import 'package:notification_chat/Controllers/user_controller.dart';
import 'package:notification_chat/Localdata/local_data.dart';
import 'package:notification_chat/Utils/routes/routes_name.dart';
import 'package:notification_chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});
  final userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: constantSheet.services.screenWidth(context),
            padding: EdgeInsets.all(15.sp).copyWith(top: 0, bottom: 20.h),
            decoration: BoxDecoration(
                color: constantSheet.colors.primary,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20.r),
                    bottomLeft: Radius.circular(20.r))),
            child: SafeArea(
              child: GetBuilder<UserController>(
                builder: (controller) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          controller.userdata.userName ?? "",
                          style: constantSheet.textTheme.fs24Medium
                              .copyWith(color: constantSheet.colors.white),
                        ),
                      ),
                      Gap(10.h),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: CachedNetworkImage(
                              height: 80.sp,
                              width: 80.sp,
                              fit: BoxFit.cover,
                              imageUrl: controller
                                      .userdata.profileImage!.isNotEmpty
                                  ? controller.userdata.profileImage!
                                  : "https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW1hZ2V8ZW58MHx8MHx8fDA%3D",
                              placeholder: (context, url) => SizedBox(
                                height: 15.sp,
                                width: 15.sp,
                                child: CircularProgressIndicator(
                                  color: constantSheet.colors.yellowlight,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          Gap(10.h),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(2.h),
                              Text(
                                controller.userdata.name ?? "",
                                style: constantSheet.textTheme.fs24Medium
                                    .copyWith(
                                        color: constantSheet.colors.white),
                              ),
                              Gap(2.h),
                              Text(
                                controller.userdata.email ?? "",
                                style: constantSheet.textTheme.fs18Medium
                                    .copyWith(
                                        color: constantSheet.colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Gap(10.h),
          ...List.generate(
            Localdata.accountTileData.length,
            (index) {
              return ListTile(
                onTap: () async {
                  tilteTapOnFunction(Localdata.accountTileData[index]["id"]);
                },
                leading:
                    Icon(Localdata.accountTileData[index]["icon"], size: 24.sp),
                title: Text(
                  Localdata.accountTileData[index]["title"],
                  style: constantSheet.textTheme.fs16Normal,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 20.sp,
                  color: constantSheet.colors.graylight,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  tilteTapOnFunction(String id) async {
    switch (id) {
      case "logout":
        await userController.logout();
      case "profile_edit":
        Get.toNamed(RouteName.editProfileScreen);
    }
  }
}
