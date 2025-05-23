
import 'package:notification_chat/Components/Constants/app_images.dart';
import 'package:notification_chat/Components/Constants/style_sheet.dart';
import 'package:notification_chat/Res/Apis/apis.dart';
import 'package:notification_chat/Services/app_services.dart';

class ConstantSheet {
  ConstantSheet._constructor();
  static final ConstantSheet instance = ConstantSheet._constructor();

  factory ConstantSheet() {
    return instance;
  }
  AppColors get colors => AppColors();
  AppTextTheme get textTheme => AppTextTheme();
  Apis get apis => Apis();
  AppServices get services => AppServices();
  AppImage get images => AppImage();
}
