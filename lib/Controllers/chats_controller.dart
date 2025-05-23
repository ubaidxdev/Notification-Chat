import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_chat/Controllers/user_controller.dart';
import 'package:notification_chat/Data/Network/networkapi_service.dart';
import 'package:notification_chat/Models/chat_model.dart';

class ChatsController {
  final _service = NetworkapiService();
  final _database = FirebaseDatabase.instance.ref("chats");

  // CREATE CHAT ROOM
  // Future<void> createChatRoom(ChatRoomModel model) async {
  //   try {
  //     await _service.post(constantSheet.apis.chatRoomReference, model.tomap());
  //   } catch (e) {
  //     debugPrint("Chat Room Create error:: =>${e.toString()} ");
  //   }
  // }

  Future setChat(String chatRoomId, ChatModel model, bool chatbool) async {
    try {
      await _database.child("$chatRoomId/messages").push().set(model.toMap());
      if (!chatbool) {
        final userController = Get.find<UserController>();
        List<String> usersId = chatRoomId.split("-");
        // //  CALL CHAT ROOM FUNCTION
        // await ChatsController().createChatRoom(roomData);
        for (var id in usersId) {
          await userController.addChateRoomId(id, chatRoomId);
        }
      }
    } catch (e) {
      debugPrint("Set DataBase data :: ${e.toString()}");
    }
  }

  void messageSeenFunction(ChatModel model, String chatroom) async {
    try {
      await FirebaseDatabase.instance
          .ref("chats")
          .child("$chatroom/messages")
          .child(model.id!)
          .update({"messagesStatus": true});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> messageDelete(ChatModel model, String chatroom) async {
    try {
      await FirebaseDatabase.instance
          .ref("chats")
          .child("$chatroom/messages")
          .child(model.id!)
          .remove();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
