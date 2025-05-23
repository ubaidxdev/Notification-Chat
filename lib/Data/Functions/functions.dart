
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notification_chat/Data/Functions/cloudinary_functions.dart';
import 'package:notification_chat/Models/chat_model.dart';
import 'package:notification_chat/Utils/Enums/enums.dart';
import 'package:notification_chat/main.dart';

class AppFunctions {
  // MESSAGE KI LIST ME SE MAX CHARACTERS RETURN KRE GA
  static List<String> getLatestMessage(
      {required List<String> messages, required int maxCharacters}) {
    List<String> result = [];
    int totalCharacters = 0;
    for (var message in messages.reversed) {
      if (totalCharacters + message.length <= maxCharacters) {
        result.insert(0, message);
        totalCharacters += messages.length;
      } else {
        break;
      }
    }
    if (result.isEmpty) return messages;
    return result;
  }

  static String chatRoomId(String user1, String user2) {
    if (user1.toLowerCase().hashCode > user2.toLowerCase().hashCode) {
      return "$user1-$user2";
    } else {
      return "$user2-$user1";
    }
  }

  static Future<String> getImageFormGallery() async {
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
  static Future<String> getImageFormCamera() async {
    var getImage =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform
            .getImageFromSource(source: ImageSource.camera);
    String image = '';
    if (getImage != null) {
      image = getImage.path;
    }
    return image;
  }

  static void showPopupMenu(
      BuildContext context, Offset position, ChatModel model, String chatroomId,
      {bool positionRight = false}) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        positionRight ? overlay.size.width : 0,
        position.dy + 25,
        positionRight ? 0 : overlay.size.width,
        0,
      ),
      items: [
        PopupMenuItem(
          value: "delete",
          child: Text(
            "Delete",
            style: constantSheet.textTheme.fs14Normal,
          ),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        print("Selected option: $value");
        popupMenudataFunction(value, model, chatroomId);
      }
    });
  }
}

popupMenudataFunction(String value, ChatModel model, String chatroomId) async {
  switch (value) {
    case "delete":
      // await ChatsController().messageDelete(model, chatroomId);
      if (model.typevalue == ChatTypes.IMAGE) {
        await CloudinaryFunctions().deleteImageFromUrl(model.data!);
      }
      break;
    default:
  }
}
