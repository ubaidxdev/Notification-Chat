import 'package:notification_chat/Data/Network/networkapi_service.dart';
import 'package:notification_chat/Models/firebase_response_model.dart';
import 'package:notification_chat/Models/user_model.dart';
import 'package:notification_chat/Utils/Enums/enums.dart';
import 'package:notification_chat/Utils/routes/routes_name.dart';
import 'package:notification_chat/Utils/utils.dart';
import 'package:notification_chat/Views/Notifications/notification_services.dart';
import 'package:notification_chat/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final _service = NetworkapiService();
  // NOTIFICATION SERVICES
  NotificationServices notificationServices = NotificationServices();

  bool _loading = false;
  bool get loading => _loading;
  setloading(bool value) {
    _loading = value;
    update();
  }

  dynamic _userdata;
  UserModel get userdata => _userdata;
  final List<String> _friendsID = [];
  List<String> get friendsID => _friendsID;

  Future<void> getDataUser(String id) async {
    try {
      final response = await _service.get(constantSheet.apis.userDocument(id))
          as FirebaseResponseModel;
      if (response.docId.isNotEmpty) {
        _userdata = UserModel.fromjson(response);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateUserStatus(bool value, DateTime time) async {
    try {
      _userdata != null
          ? await _service.update(
              constantSheet.apis.userDocument((_userdata as UserModel).id!), {
              "status": value,
              "inactiveTime": time.toString(),
            }).whenComplete(
              () {
                (_userdata as UserModel).status = value;
              },
            )
          : null;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateUserData(UserModel model) async {
    setloading(true);
    try {
      await _service
          .update(constantSheet.apis.userDocument((_userdata as UserModel).id!),
              model.tomap())
          .whenComplete(() {
        _userdata = model;
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setloading(false);
      update();
    }
  }

  Future<void> signup(Map<String, dynamic> jsondata) async {
    setloading(true);
    try {
      final uData =
          UserModel.fromjson(FirebaseResponseModel(jsondata["user"], ""));
      final checkusername = await searchuser(uData.userName!);
      if (checkusername.isEmpty) {
        UserCredential userCredential = await _service.authenticate(
                state: AuthState.SIGNUP,
                json: {"email": uData.email, "password": jsondata["password"]})
            as UserCredential;
        var id = userCredential.user!.uid;
        if (id.isNotEmpty) {
          final token =
              await notificationServices.getDeviceToken(); // GET PHONE TOKEN
          uData.token = token;
          await _service.post(
              constantSheet.apis.userDocument(id), uData.tomap());
          await prefs.setSharedPrefs(prefs.userKey, id);
          _userdata = uData.copyWith(id: id);
          Get.offNamed(RouteName.bottomNavigationBarScreen); // NEXT SCREEN
        }
      } else {
        AppUtils.messageSnakeBar(
            "Please", "change UserName beacuse this UserName is alreday used");
      }
    } catch (e) {
      debugPrint("=================");
      debugPrint(e.toString());
      debugPrint("=================");
    } finally {
      update();
      setloading(false);
    }
  }

  Future<void> login(Map<String, dynamic> json) async {
    setloading(true);
    String email = json["email"];
    String password = json["password"];
    try {
      final snapshot = await _service.get(
              constantSheet.apis.userReference.where("email", isEqualTo: email))
          as List<FirebaseResponseModel>;
      if (snapshot.first.docId.isNotEmpty) {
        UserModel data = UserModel.fromjson(
            snapshot.first); // USER DATA CONVERT TO USER MODEL
        await _service.authenticate(
            state: AuthState.LOGIN,
            json: {"email": data.email, "password": password});
        final token =
            await notificationServices.getDeviceToken(); // GET PHONE TOKEN
        await _service.update(
            constantSheet.apis.userDocument(data.id!), {"token": token});
        await prefs.setSharedPrefs(prefs.userKey,
            snapshot.first.docId); // SET USER ID SharedPreferences
        _userdata = UserModel();
        _userdata = data; // SET DATA
        await updateUserStatus(true, DateTime.now());
        Get.offNamed(RouteName.bottomNavigationBarScreen); // NEXT SCREEN
      }
    } catch (e) {
      debugPrint("====================");
      debugPrint(e.toString());
      debugPrint("====================");
    } finally {
      update();
      setloading(false);
    }
  }

  // LOGOUT
  Future<void> logout() async {
    setloading(true);
    try {
      await _service.authenticate(state: AuthState.LOGOUT);
      prefs.removSharedPrefs(prefs.userKey);
      await updateUserStatus(false, DateTime.now());
      Get.offAllNamed(RouteName.loginScreen);
    } catch (e) {
      debugPrint("------------------");
      debugPrint(e.toString());
      debugPrint("------------------");
    } finally {
      update();
      setloading(false);
    }
  }

  Future<String> searchuser(String value) async {
    String id = "";
    try {
      final response = await _service.get(constantSheet.apis.userReference
          .where("userName", isEqualTo: value)) as List<FirebaseResponseModel>;
      if (response.isNotEmpty) {
        final db = UserModel.fromjson(response[0]);
        id = db.id!;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return id;
  }

  Future addChateRoomId(String userId, String chatRoomID) async {
    try {
      await _service.update(constantSheet.apis.userDocument(userId), {
        "chatRoomIds": FieldValue.arrayUnion([chatRoomID])
      });
      if (userId == (_userdata as UserModel).id) {
        bool value =
            (_userdata as UserModel).chatRoomIds!.any((e) => e == chatRoomID);
        if (!value) {
          (_userdata as UserModel).chatRoomIds!.add(chatRoomID);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      update();
    }
  }

  Future<void> istokanGet() async {
    if (_userdata == null) return;
    final data = _userdata as UserModel;
    if (data.token == null || data.token!.isEmpty) {
      final token =
          await notificationServices.getDeviceToken(); // GET PHONE TOKEN
      await _service
          .update(constantSheet.apis.userDocument(data.id!), {"token": token});
      data.token = token;
      _userdata = data;
      update();
    }
  }
}
