import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/services/api_provider.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../screens/user_page.dart';
import '../screens/auth/login.dart';
import 'main_screen.dart';

class Root extends GetWidget<AuthController> {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.user?.uid != null) { controller.isLogin.value = true; }

    Get.find<ApiProvider>().initUserInfo();

    return Obx(
      () {
        if (controller.isLogin.value) {
          return MainScreen();
        } else {
          return Login();
        }
      },
    );
  }
}
