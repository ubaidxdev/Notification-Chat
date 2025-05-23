import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._constructor();
  static get instance => SharedPrefs._constructor();

  static late SharedPreferences _preferences;
  getpref() async {
    _preferences = await SharedPreferences.getInstance();
  }

  //  ALL KEYS
  get userKey => "userKey";
  get savedToken => "savedToken";
  get expiryTokenTime => "expiryTokenTime";

  Future<dynamic> setSharedPrefs(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  String getSharedPrefs(String key) {
    String? value = _preferences.getString(key) ?? "";
    if (value.isNotEmpty) {
      return value;
    }
    return "";
  }

  Future<bool> setListSharedPrefs(String key, List<String> value) async {
    return await _preferences.setStringList(key, value);
  }

  List<String> getListSharedPrefs(String key) {
    return _preferences.getStringList(key) ?? [];
  }

  Future<bool> setMapSharedPrefs(String key, Map<String, dynamic> value) async {
    return await _preferences.setString(key, json.encode(value));
  }

  Future<bool> removSharedPrefs(String key) async {
    return await _preferences.remove(key);
  }
}
