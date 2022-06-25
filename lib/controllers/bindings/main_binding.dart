import 'package:dio/dio.dart';
import 'package:flutter_recruit_asked/controllers/mainscreen_controller.dart';
import 'package:flutter_recruit_asked/controllers/question_controller.dart';
import 'package:flutter_recruit_asked/services/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../auth_controller.dart';
import '../user_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Dio());
    Get.lazyPut(() => ImagePicker());
    Get.lazyPut(() => FlutterSecureStorage());

    Get.put<UserController>(UserController(), permanent: true);
    Get.put<ApiProvider>(ApiProvider(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);

    Get.put<MainScreenController>(MainScreenController(), permanent: true);

    Get.put<QuestionController>(QuestionController());
  }
}
