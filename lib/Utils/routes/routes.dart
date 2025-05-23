import 'package:notification_chat/Views/Authentication/login_screen.dart';
import 'package:notification_chat/Views/Authentication/signup_screen.dart';
import 'package:notification_chat/Views/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:notification_chat/Views/OnBoarding/splash.dart';
import 'package:notification_chat/Views/home/account_screen.dart';
import 'package:notification_chat/Views/home/edit_profile_screen.dart';
import 'package:notification_chat/Views/home/home_screen.dart';
import 'package:get/get.dart';

import 'routes_name.dart';

List<GetPage<dynamic>> routes = [
  GetPage(name: RouteName.splashScreen, page: () => const SplashScreen()),
  GetPage(
      name: RouteName.bottomNavigationBarScreen,
      page: () => const BottomNavigationBarScreen()),
  GetPage(name: RouteName.signUpScreen, page: () => const SignupScreen()),
  GetPage(name: RouteName.loginScreen, page: () => LoginScreen()),
  GetPage(name: RouteName.homeScreen, page: () => const HomeScreen()),
  GetPage(name: RouteName.accountScreen, page: () => AccountScreen()),
  GetPage(
      name: RouteName.editProfileScreen, page: () => const EditProfileScreen()),
];
