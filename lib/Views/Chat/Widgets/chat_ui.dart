import 'package:cached_network_image/cached_network_image.dart';
import 'package:notification_chat/Models/chat_model.dart';
import 'package:notification_chat/Utils/Enums/enums.dart';
import 'package:notification_chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget chatUi(ChatModel model, BuildContext context) {
  switch (model.typevalue) {
    case ChatTypes.MESSAGE:
      return Text(model.data.toString(),
          style: constantSheet.textTheme.fs16Normal
              .copyWith(color: constantSheet.colors.black));
    case ChatTypes.IMAGE:
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: CachedNetworkImage(
          height: 200,
          width: constantSheet.services.screenWidth(context) * 0.6,
          fit: BoxFit.cover,
          imageUrl: model.data ?? "",
          placeholder: (context, url) => SizedBox(
            height: 5.sp,
            width: 5.sp,
            child: Center(
              child: CircularProgressIndicator(
                color: constantSheet.colors.white,
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    default:
      return const SizedBox();
  }
}
