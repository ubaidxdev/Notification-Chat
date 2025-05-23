

import 'package:notification_chat/Utils/Enums/enums.dart';

abstract class BaseapiService {
  Future<dynamic> authenticate(
      {required AuthState state, Map<String, dynamic>? json});
  Future<dynamic> post(dynamic path, Map<String, dynamic> data);
  Future<dynamic> get(dynamic path);
  Future<dynamic> update(dynamic path, Map<String, dynamic> data);
}
