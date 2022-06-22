import 'package:dio/dio.dart';
import 'package:flutter_recruit_asked/controllers/mainscreen_controller.dart';
import 'package:flutter_recruit_asked/controllers/question_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../auth_controller.dart';
import '../user_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Dio());
    Get.lazyPut(() => ImagePicker());

    Get.put<MainScreenController>(MainScreenController(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);

    Get.put<QuestionController>(QuestionController());
  }
}
