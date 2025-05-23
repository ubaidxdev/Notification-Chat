import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:notification_chat/Controllers/user_controller.dart';
import 'package:notification_chat/Data/Functions/functions.dart';
import 'package:notification_chat/Data/Network/networkapi_service.dart';
import 'package:notification_chat/Views/Notifications/user_notification_database.dart';
import 'package:notification_chat/main.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotification(RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );
    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle when user taps on the notification
        if (details.actionId == null) {
          handleMessage(message);
          return;
        }

        //  HANDLE REPLY ACTION
        if (details.actionId == "reply_action") {
          String? replyText = details.input; // Get reply message
          debugPrint("Reply Message => $replyText");
        }
      },
      onDidReceiveBackgroundNotificationResponse:
          backgroundNotificationResponse,
    );
  }

  Future<void> firebaseInit() async {
    FirebaseMessaging.onMessage.listen((message) async {
      if (Platform.isAndroid) {
        // await initLocalNotification(message);
        await showNotification(message);
      } else {
        await showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    if (message.data.isEmpty) return;
    // DATA
    String senderId = message.data['senderId'] ?? 'Unknown User';
    String senderName = message.data["title"] ?? 'Unknown';
    String newMessage = message.data["body"] ?? '';
    String chatRoomId = message.data["chatRoomId"] ?? '';

    // Fetch old messages & add the new one
    List<String> messages =
        await UserNotificationDatabase.manageNotificationLocalData(
          id: senderId,
          message: newMessage,
        );

    /// CALL GETLATESTMESSAGE FUNCTION
    List<String> maxMessage = AppFunctions.getLatestMessage(
      messages: messages,
      maxCharacters: 150,
    );

    // Limit visible messages to 6
    int maxVisibleMessages = 6;
    List<String> visibleMessages =
        maxMessage.length > maxVisibleMessages
            ? maxMessage.sublist(
              maxMessage.length - maxVisibleMessages,
            ) // Last 6 messages
            : maxMessage;

    String summaryText =
        maxMessage.length > maxVisibleMessages
            ? "+${maxMessage.length - maxVisibleMessages} more messages"
            : "";

    // User Reply ke liye TextField
    var replyInput = const AndroidNotificationActionInput(
      label: 'Type your reply...',
    );
    var replyAction = AndroidNotificationAction(
      "reply_action",
      "Reply",
      inputs: [replyInput],
      // icon: ByteArrayAndroidBitmap.fromBase64String('@mipmap/ic_launcher'),
    );

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      "1001",
      "Chat Notifications",
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
    // INBOX STYLE
    InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
      visibleMessages,
      contentTitle: "$senderName (${messages.length} messages)",
      summaryText: summaryText,
    );
    // ANDROID
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: "your Channel description",
          styleInformation: inboxStyleInformation,
          actions: [replyAction], // Reply action button here
          groupKey: senderName,
          setAsGroupSummary: true,
          importance: Importance.high,
          priority: Priority.high,
          ticker: "ticker",
          icon: "@mipmap/ic_launcher",
        );
    //IOS
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // final id = int.tryParse(message.data["id"] ?? "0") ?? 100;
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        senderId.hashCode,
        senderName,
        visibleMessages.join("\n"),
        notificationDetails,
        payload: chatRoomId,
      );
    });
  }

  void requestNotificationPremission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {
      debugPrint("User Premission denied");
    }
  }

  Future<String> getDeviceToken() async {
    String token = "";
    try {
      token = await messaging.getToken() ?? "";
    } catch (e) {
      debugPrint("GET TOKEN ERROR : $e");
    }
    return token;
  }

  Future<void> isTokenRefresh() async {
    final userController = Get.find<UserController>();
    final service = NetworkapiService();
    try {
      messaging.onTokenRefresh.listen((event) async {
        var token = event.toString();
        await service.update(
          constantSheet.apis.userDocument(userController.userdata.id!),
          {"token": token},
        );
      });
    } catch (e) {
      debugPrint("TOKEN REFRESH ERROR : $e");
    }
  }

  Future<void> setupInteractMessage() async {
    // JB APP TERMINATED HO
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    // JB APP BACKGROUND
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(event);
    });
  }

  // NOTIFICATION TAP SE KISI SCREEN PR JANE KE LIYE
  void handleMessage(RemoteMessage message) {}
}

      // Future.delayed(const Duration(seconds: 1), () {
      //   _flutterLocalNotificationsPlugin.show(
      //     0,
      //     "New Messages",
      //     "आपके पास नए मैसेज हैं",
      //     NotificationDetails(
      //       android: AndroidNotificationDetails(
      //         channel.id,
      //         channel.name,
      //         channelDescription: "your Channel description",
      //         importance: Importance.high,
      //         priority: Priority.high,
      //         groupKey: "jaat",
      //         setAsGroupSummary: true,
      //       ),
      //     ),
      //   );
      // });