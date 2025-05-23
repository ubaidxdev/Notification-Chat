import 'package:notification_chat/Models/all_models.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlLiteHelper {
  static String messageTable = "messages";

  SqlLiteHelper._internal();
  static final SqlLiteHelper _instance = SqlLiteHelper._internal();

  factory SqlLiteHelper() => _instance;

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), "my_database.db");
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// MESSAGE TABLE NOTIFICATION
  /// KEY KO NOTIFICATION LOCAL MODEL ME STORE KI GYI HAI
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE $messageTable (
      ${NotificationLocalModel.userIdKey} TEXT PRIMARY KEY,
      ${NotificationLocalModel.messagesKey} TEXT,
      ${NotificationLocalModel.timestampKey} TEXT NOT NULL,
      FOREIGN KEY (${NotificationLocalModel.userIdKey}) REFERENCES users(id) ON DELETE CASCADE
    )
    ''',
    );
  }

  Future<bool> checkTableExists(String tableName) async {
    final db = await SqlLiteHelper().database;
    final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [tableName]);
    return result.isNotEmpty;
  }

  Future<void> deleteOldDatabase() async {
    String path = join(await getDatabasesPath(), "my_database.db");
    await deleteDatabase(path);
    _database = null;
    debugPrint("Old database deleted successfully!");
  }
}
