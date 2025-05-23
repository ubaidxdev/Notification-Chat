import 'package:notification_chat/Components/Buttons/primary_button.dart';
import 'package:notification_chat/Components/TextFields/primary_text_form_field.dart';
import 'package:notification_chat/Controllers/user_controller.dart';
import 'package:notification_chat/Services/appconfig.dart';
import 'package:notification_chat/Utils/app_validators%20copy.dart';
import 'package:notification_chat/Utils/routes/routes_name.dart';
import 'package:notification_chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final Rx<bool> passwordShow = true.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantSheet.colors.bg,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15.0.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppConfig.appName,
                      style: constantSheet.textTheme.fs35Medium
                          .copyWith(color: constantSheet.colors.primary)),
                  Gap(25.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(TextSpan(
                        text: "Hello \n",
                        style: constantSheet.textTheme.fs24Medium,
                        children: <TextSpan>[
                          TextSpan(
                              text: "Welcome back!",
                              style: TextStyle(
                                  color: constantSheet.colors.yellowlight))
                        ])),
                  ),
                  Gap(25.h),
                  Form(
                      key: _key,
                      child: Column(
                        children: [
                          PrimaryTextFormField(
                            hinttext: "Email",
                            controller: _emailController,
                            validator: EmailValidator(),
                          ),
                          Gap(25.h),
                          Obx(
                            () => PrimaryTextFormField(
                              hinttext: "Password",
                              controller: _passwordController,
                              validator: PasswordValidator(),
                              obscureText: passwordShow.value,
                              suffixiconOnTap: () {
                                passwordShow.value = !passwordShow.value;
                              },
                              suffixicon: passwordShow.value == true
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          )
                        ],
                      )),
                  Gap(45.h),
                  GetBuilder<UserController>(
                    builder: (controller) => PrimaryButton(
                      title: "Login",
                      isExpanded: true,
                      isloading: controller.loading,
                      onPressed: () async {
                        _getValideTextField();
                      },
                    ),
                  ),
                  Gap(50.h),
                  GestureDetector(
                    onTap: () {
                      Get.offNamed(RouteName.signUpScreen);
                    },
                    child: Text.rich(TextSpan(
                        text: "Not a member? ",
                        style: constantSheet.textTheme.fs16Normal,
                        children: <TextSpan>[
                          TextSpan(
                              text: "Register now",
                              style: TextStyle(
                                  color: constantSheet.colors.primary))
                        ])),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getValideTextField() async {
    final userController = Get.find<UserController>();
    if (_key.currentState!.validate()) {
      await userController.login({
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
      });
    }
  }
}
