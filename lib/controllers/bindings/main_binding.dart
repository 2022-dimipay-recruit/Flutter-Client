import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../auth_controller.dart';
import '../user_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Dio());

    Get.put<UserController>(UserController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
