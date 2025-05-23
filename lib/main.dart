import 'dart:async';

import 'package:notification_chat/Classes/constant_sheet.dart';
import 'package:notification_chat/Controllers/app_initialbinding.dart';
import 'package:notification_chat/Preferences/sharedpreferences.dart';
import 'package:notification_chat/SQL/sql_lite.dart';
import 'package:notification_chat/Services/appconfig.dart';
import 'package:notification_chat/Utils/routes/routes.dart';
import 'package:notification_chat/Utils/routes/routes_name.dart';
import 'package:notification_chat/Views/Notifications/notification_services.dart';
import 'package:notification_chat/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

late ConstantSheet constantSheet;
SharedPrefs prefs = SharedPrefs.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundMessage);
  await prefs.getpref();
  await SqlLiteHelper().database; // Database initialize
  await NotificationServices().firebaseInit();
  runApp(const MyApp());
}

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundMessage(RemoteMessage message) async {
  await SqlLiteHelper().database; // Database initialize
  await Firebase.initializeApp();
  await NotificationServices().initLocalNotification(message);
  await NotificationServices().showNotification(message);
}

@pragma("vm:entry-point")
void backgroundNotificationResponse(NotificationResponse details) {
  print(
      "🔔 (BG) Background Notification Response Received: ${details.actionId}");

  if (details.actionId == "reply_action") {
    String? replyText = details.input;
    print("📩 (BG) Reply Message Received: $replyText");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        constantSheet = ConstantSheet.instance;
        return GetMaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          getPages: routes,
          initialRoute: RouteName.splashScreen,
          initialBinding: AppInitialbinding(),
          debugShowCheckedModeBanner: false,
        );
      },
      designSize: Size(AppConfig.screenWidth, AppConfig.screenHeight),
    );
  }
}
