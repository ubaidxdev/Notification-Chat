import 'package:get/get.dart';
import 'user_controller.dart';

class AppInitialbinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserController());
  }
}
