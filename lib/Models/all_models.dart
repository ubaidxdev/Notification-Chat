import 'dart:convert';

class NotificationLocalModel {
  // LOCAL DATA KEY
  static String userIdKey = "user_id";
  static String messagesKey = "messages";
  static String timestampKey = "timestamp";

  String id;
  String? time;
  List<String>? messages;
  NotificationLocalModel({
    required this.id,
    this.time,
    this.messages,
  });

  // FROM JSON
  NotificationLocalModel.fromjson(Map<String, dynamic> json)
      : id = (json[userIdKey] ?? "").toString(),
        time = json[timestampKey] ?? "",
        messages = ((jsonDecode(json[messagesKey] ?? "")) as List)
            .map((e) => e.toString())
            .toList();
}
