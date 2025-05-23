import 'dart:convert';

import 'package:notification_chat/Models/all_models.dart';
import 'package:notification_chat/SQL/sql_lite.dart';
import 'package:sqflite/sql.dart';

class UserNotificationDatabase {
  /// USER OLD NOTIFICATION DATA GET OR NEW MESSAGE SET
  /// USER KA DATA LOCAL ME SET HAI TO UPDATE KREGA NHI TO SET KREGA
  static Future<List<String>> manageNotificationLocalData(
      {required String id, required String message}) async {
    final getMessage = await getNotificationsSqLiteData(id); // GET OLD DATA
    List<String> allMessages =
        getMessage != null ? (getMessage.messages ?? []) : [];
    allMessages.add(message); // ADD NEW MESSAGE
    // SET NEW USER AND DATA
    await setNotificationsSqLiteData(
        model: NotificationLocalModel(id: id, messages: allMessages));
    return allMessages; // RETURN LIST STRING
  }

  // GET USER NOTIFICATION LOCAL DATA
  static Future<NotificationLocalModel?> getNotificationsSqLiteData(
      String userId) async {
    final db = await SqlLiteHelper().database;
    final result = await db.query(
      SqlLiteHelper.messageTable,
      where: "${NotificationLocalModel.userIdKey} = ?",
      whereArgs: [userId],
    );
    print(result.length);
    // DATA HAI TO NOTIFICATION LOCAL MODEL RETURN HOGA NHI TO NULL
    if (result.isNotEmpty) return NotificationLocalModel.fromjson(result.first);
    return null;
  }

  // SET USER NOTIFICATION LOCAL DATA
  static Future<bool> setNotificationsSqLiteData(
      {required NotificationLocalModel model}) async {
    final db = await SqlLiteHelper().database;
    final result = await db.insert(
      SqlLiteHelper.messageTable,
      {
        NotificationLocalModel.userIdKey: model.id,
        NotificationLocalModel.messagesKey: jsonEncode(model.messages),
        NotificationLocalModel.timestampKey:
            DateTime.now().millisecondsSinceEpoch.toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result.hashCode > 0;
  }

  /// UPDATE USER NOTIFICATION LOCAL DATA
  /// TIME AND MESSAGES
  static Future<bool> updateNotificationsSqLiteData(
      {required NotificationLocalModel model}) async {
    final db = await SqlLiteHelper().database;
    final String time =
        DateTime.now().millisecondsSinceEpoch.toString(); // TIME
    final String messages = jsonEncode(model.messages); // MESSAGES
    final result = await db.update(
      SqlLiteHelper.messageTable,
      {
        NotificationLocalModel.messagesKey: messages,
        NotificationLocalModel.timestampKey: time,
      },
      where: "${NotificationLocalModel.userIdKey} = ?",
      whereArgs: [model.id],
    );
    return result.hashCode > 0;
  }
}
