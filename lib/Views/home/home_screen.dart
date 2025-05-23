import 'package:notification_chat/Components/Buttons/primary_button.dart';
import 'package:notification_chat/Components/TextFields/search_text_form_field.dart';
import 'package:notification_chat/Components/Tiles/user_tile.dart';
import 'package:notification_chat/Controllers/user_controller.dart';
import 'package:notification_chat/Models/all_models.dart';
import 'package:notification_chat/Models/firebase_response_model.dart';
import 'package:notification_chat/Models/user_model.dart';
import 'package:notification_chat/SQL/sql_lite.dart';
import 'package:notification_chat/Services/appconfig.dart';
import 'package:notification_chat/Utils/utils.dart';
import 'package:notification_chat/Views/Notifications/notification_services.dart';
import 'package:notification_chat/Views/Notifications/user_notification_database.dart';
import 'package:notification_chat/Views/Widgets/stream_builder_widget.dart';
import 'package:notification_chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final userController = Get.find<UserController>();
  final searchController = TextEditingController();

  String searchUserData = "";
  final searchfocusNode = FocusNode();

  // NOTIFICATION SERVICES
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    useronline();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    notificationServices.requestNotificationPremission();
    notificationServices.setupInteractMessage();
    // notificationServices.getDeviceToken();
    // notificationServices.isTokenRefresh();
  }

  useronline() async {
    if (userController.userdata.status == false) {
      await userController.updateUserStatus(true, DateTime.now());
    }
    await userController.istokanGet();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      await userController.updateUserStatus(true, DateTime.now());
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      await userController.updateUserStatus(false, DateTime.now());
    } else if (state == AppLifecycleState.detached) {
      await userController.updateUserStatus(false, DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        "User on Login this App ::${userController.userdata.name}, id ::${userController.userdata.id}");
    return Scaffold(
        appBar: AppBar(
          backgroundColor: constantSheet.colors.primary,
          title: Text(AppConfig.appName,
              style: constantSheet.textTheme.fs24Normal
                  .copyWith(color: constantSheet.colors.white)),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(15.sp),
                child: Column(children: [
                  SearchTextFormField(
                      focusNode: searchfocusNode,
                      hinttext: "Search user name",
                      controller: searchController,
                      iconOnTap: () async {
                        if (userController.userdata.userName !=
                            searchController.text.trim()) {
                          final data = await userController
                              .searchuser(searchController.text.trim());
                          if (data.isNotEmpty) {
                            searchUserData = data;
                            searchController.clear();
                            searchfocusNode.unfocus();
                            setState(() {});
                          } else {
                            return AppUtils.messageSnakeBar(
                                "No!", "User found");
                          }
                        }
                      }),
                  GetBuilder<UserController>(
                    builder: (controller) {
                      return searchUserData.isNotEmpty
                          ? UserTile(
                              id: searchUserData,
                              tileOntap: () {
                                searchUserData = "";
                                setState(() {});
                              },
                            )
                          : controller.userdata.chatRoomIds!.isNotEmpty
                              ? StreamBuilderWidget(
                                  stream: constantSheet.apis
                                      .userDocument(controller.userdata.id!)
                                      .snapshots(),
                                  widget: (snapshot) {
                                    final chatRoomids = UserModel.fromjson(
                                            FirebaseResponseModel.fromResponse(
                                                snapshot.requireData))
                                        .chatRoomIds;
                                    List<String> ids = [];
                                    for (var element in chatRoomids!) {
                                      final id = element.split("-");
                                      id.removeWhere(
                                          (e) => e == controller.userdata.id);
                                      if (id.isNotEmpty) {
                                        ids.add(id[0]);
                                      }
                                    }
                                    return ListView.builder(
                                        itemCount: ids.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return UserTile(
                                            id: ids[index],
                                            tileOntap: () {
                                              searchfocusNode.unfocus();
                                            },
                                          );
                                        });
                                  },
                                )
                              : Text(
                                  "No one is there to chat in your friends list please search your friend and chat",
                                  style: constantSheet.textTheme.fs14Normal
                                      .copyWith(
                                          color:
                                              constantSheet.colors.graylight),
                                  textAlign: TextAlign.center,
                                ).marginOnly(top: 10.h);
                    },
                  ),
                  PrimaryButton(
                      title: "All messages",
                      onPressed: () async {
                        final value = await UserNotificationDatabase
                            .manageNotificationLocalData(
                                id: "123456", message: "Hello Ram");
                        print("Value :::: $value");
                      }),
                  Gap(20.h),
                  PrimaryButton(
                      title: "Set Data",
                      onPressed: () async {
                        final value = await UserNotificationDatabase
                            .setNotificationsSqLiteData(
                                model: NotificationLocalModel(
                                    id: "123456", messages: ["Kese ho"]));
                        print("Value :::: $value");
                      }),
                  Gap(20.h),
                  PrimaryButton(
                      title: "Update Data",
                      onPressed: () async {
                        final value = await UserNotificationDatabase
                            .updateNotificationsSqLiteData(
                                model: NotificationLocalModel(
                                    id: "123456", messages: []));
                        print("Value :::: $value");
                      }),
                  Gap(20.h),
                  PrimaryButton(
                      title: "Get Data",
                      onPressed: () async {
                        final data = await UserNotificationDatabase
                            .getNotificationsSqLiteData(
                                "ZJuvKGsn1QSfZDNp9m4TfrFL4Eg1");
                        print("===========");
                        if (data != null) {
                          print(data.id);
                          print(data.messages);
                          print(data.time);
                        }
                        print("===========");
                      }),
                  Gap(20.h),
                  PrimaryButton(
                      title: "Delete Data",
                      onPressed: () async {
                        await SqlLiteHelper().deleteOldDatabase();
                      }),
                ]))));
  }
}
