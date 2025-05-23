import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:notification_chat/main.dart';

class SendNotification {
  static String? _getSavedAccessToken() {
    final token = prefs.getSharedPrefs(prefs.savedToken);
    final expiry = prefs.getSharedPrefs(prefs.expiryTokenTime);
    if (token.isNotEmpty && expiry.isNotEmpty) {
      final expiryTime = DateTime.parse(expiry);
      if (expiryTime.isAfter(DateTime.now().add(const Duration(minutes: 5)))) {
        return token;
      } else {
        return null;
      }
    }
    return null;
  }

  // GET  ACCESS TOKEN
  static Future<String> _getAccessToken() async {
    String? savedToken = _getSavedAccessToken();

    if (savedToken != null) {
      return savedToken;
    }
    // 🚫 IMPORTANT: service_account.json is NOT included in this repository.
    // ------------------------------------------------------------
    // 🔒 This file contains sensitive credentials (Firebase Service Account)
    // and has been excluded from the repository for security and privacy reasons.
    // If you're setting up this project, please generate your own service_account.json
    // from your Firebase Console and place it under: assets/Jsons/service_account.json
    //
    // ✅ For Demo Purpose: You can mock the service or disable notification logic.
    final serviceAccountJson = {};
    // Sorry, I can't provide the actual content of the service account JSON file.
    // Replace with your actual service account JSON content

    // ------------------------------------------------------------
    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials caccessCredentials = await auth
        .obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client,
        );

    client.close();

    await prefs.setSharedPrefs(
      prefs.savedToken,
      caccessCredentials.accessToken.data,
    );
    await prefs.setSharedPrefs(
      prefs.expiryTokenTime,
      caccessCredentials.accessToken.expiry.toIso8601String(),
    );

    return caccessCredentials.accessToken.data;
  }

  // SEND NOTIFICATION
  static Future<void> sendNotification({
    required String deviceToken,
    required String name,
    required String text,
    required String chatRoomId,
    required String senderId,
  }) async {
    try {
      final String serverAccessToken = await _getAccessToken();

      String url =
          "https://fcm.googleapis.com/v1/projects/chatapp-88623/messages:send";

      // MESSAGE DATA
      final Map<String, dynamic> message = {
        "message": {
          "token": deviceToken,
          // "notification": {
          //   "title": name,
          //   "body": text,
          // },
          "data": {
            "title": name,
            "body": text,
            "type": "Chat",
            "chatRoomId": chatRoomId,
            "senderId": senderId,
          },
        },
      };

      await http.post(
        Uri.parse(url),

        // body: ,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $serverAccessToken",
        },
        body: jsonEncode(message),
      );
    } catch (e) {
      debugPrint("Send Notification Function Error : ${e.toString()}");
    }
  }
}
