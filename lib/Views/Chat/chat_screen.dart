import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:notification_chat/Components/TextFields/message_textfield.dart';
import 'package:notification_chat/Controllers/chats_controller.dart';
import 'package:notification_chat/Controllers/user_controller.dart';
import 'package:notification_chat/Data/Functions/Cloudinary_functions.dart';
import 'package:notification_chat/Data/Functions/functions.dart';
import 'package:notification_chat/Models/all_models.dart';
import 'package:notification_chat/Models/chat_model.dart';
import 'package:notification_chat/Models/user_model.dart';
import 'package:notification_chat/Utils/Enums/enums.dart';
import 'package:notification_chat/Views/Chat/Widgets/chat_ui.dart';
import 'package:notification_chat/Views/Chat/image_send_screen.dart';
import 'package:notification_chat/Views/Notifications/send_notification.dart';
import 'package:notification_chat/Views/Notifications/user_notification_database.dart';
import 'package:notification_chat/main.dart';

class ChatScreen extends StatefulWidget {
  final UserModel model;
  const ChatScreen({super.key, required this.model});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageFieldcontroller = TextEditingController();
  String chatroom = "";
  bool chatbool = false;
  ScrollController scrollController = ScrollController();
  final userController = Get.find<UserController>();
  @override
  void initState() {
    super.initState();
    dataManage();
  }

  void dataManage() async {
    chatroom = AppFunctions.chatRoomId(
      userController.userdata.id!,
      widget.model.id!,
    );
    chatbool = widget.model.chatRoomIds!.any((element) => element == chatroom);
    await UserNotificationDatabase.updateNotificationsSqLiteData(
      model: NotificationLocalModel(id: widget.model.id!, messages: []),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.model.id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: constantSheet.colors.primary,
        leadingWidth: 30.w,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            size: 30.sp,
            color: constantSheet.colors.white,
          ),
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: CachedNetworkImage(
                height: 35,
                width: 35,
                fit: BoxFit.cover,
                imageUrl:
                    widget.model.profileImage!.isNotEmpty
                        ? widget.model.profileImage!
                        : "https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW1hZ2V8ZW58MHx8MHx8fDA%3D",
                placeholder:
                    (context, url) => SizedBox(
                      height: 15.sp,
                      width: 15.sp,
                      child: CircularProgressIndicator(
                        color: constantSheet.colors.yellowlight,
                      ),
                    ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Gap(5.w),
            Text(
              widget.model.name ?? "",
              style: constantSheet.textTheme.fs24Normal.copyWith(
                color: constantSheet.colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0.sp),
        child: Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                controller: scrollController,
                query: FirebaseDatabase.instance
                    .ref("chats")
                    .child("$chatroom/messages"),
                itemBuilder: (context, snapshot, animation, index) {
                  // print("---------------");
                  // WidgetsBinding.instance
                  //     .addPostFrameCallback((_) => _scrollToBottom());
                  final data = ChatModel.fromejson(
                    snapshot.value! as Map<Object?, Object?>,
                    snapshot.key!,
                  );
                  if (data.senderid != userController.userdata.id &&
                      data.messagesStatus == false) {
                    ChatsController().messageSeenFunction(data, chatroom);
                  }
                  if (widget.model.id == data.senderid) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: constantSheet.colors.yellowlight,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: chatUi(data, context),
                      ),
                    );
                  } else {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: constantSheet.colors.yellowlight,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: GestureDetector(
                              onLongPressDown: (LongPressDownDetails details) {
                                AppFunctions.showPopupMenu(
                                  context,
                                  details.globalPosition,
                                  data,
                                  chatroom,
                                  positionRight: true,
                                );
                              },
                              child: chatUi(data, context),
                            ),
                          ),
                          Positioned(
                            right: 2.w,
                            bottom: 5.h,
                            child: Icon(
                              data.messagesStatus!
                                  ? Icons.check_circle_rounded
                                  : Icons.check_circle_outline_outlined,
                              color:
                                  data.messagesStatus!
                                      ? constantSheet.colors.green
                                      : constantSheet.colors.black,
                              size: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MessageTextfield(
        controller: messageFieldcontroller,
        onFieldSubmitted: () async {
          await chatHandleFunction();
        },
        cameraOntap: () async {
          final db = await AppFunctions.getImageFormGallery();
          final imagePath = File(db);
          if (imagePath.path.isNotEmpty) {
            Get.to(
              () => ImageSendScreen(
                file: imagePath,
                ontap: () async {
                  // final image =
                  //     await FirestorageFuction().uploadFile(imagePath);
                  final imageURL = await CloudinaryFunctions()
                      .uploadImageToCloudinary(imagePath);
                  if (imageURL.isNotEmpty) {
                    await chatHandleFunction(
                      data: imageURL,
                      type: ChatTypes.IMAGE,
                    );
                  }
                  Get.back();
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> chatHandleFunction({String? data, ChatTypes? type}) async {
    // CHAT DATA SET
    final chat = ChatModel(
      senderid: userController.userdata.id,
      data: data ?? messageFieldcontroller.text,
      typevalue: type ?? ChatTypes.MESSAGE,
    );
    // CHAKE CHAT DATA
    if (chat.data == null || chat.data!.isNotEmpty || data != null) {
      _scrollToBottom();
      messageFieldcontroller.clear(); // CLEAR MESSAGE FIELD
      await ChatsController().setChat(
        chatroom,
        chat,
        chatbool,
      ); // SENT CHAT DATA
      // SEND NOTIFICATION
      await SendNotification.sendNotification(
        deviceToken: widget.model.token ?? "",
        name: userController.userdata.name ?? "",
        text: chat.data ?? messageFieldcontroller.text,
        chatRoomId: chatroom,
        senderId: userController.userdata.id ?? "unknown_user",
      );
    }
  }

  // SCROOLL TO BOOTOM MESSAGE LIST
  void _scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }
}
