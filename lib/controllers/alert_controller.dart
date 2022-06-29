import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/models/comment.dart';
import 'package:flutter_recruit_asked/models/question.dart';
import 'package:flutter_recruit_asked/models/user.dart';
import 'package:flutter_recruit_asked/screens/widgets/sort_button.dart';
import 'package:flutter_recruit_asked/services/api_provider.dart';
import 'package:flutter_recruit_asked/services/shared_preference.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../models/alert.dart';
import 'mainscreen_controller.dart';

enum AlertType {
  newPost,
  newAnswer,
  newReport,
  newFollow,
  none,
}

extension AlertTypeExtension on AlertType {
  String get convertStr {
    switch (this) {
      case AlertType.newPost: return "NEW_POST";
      case AlertType.newAnswer: return "NEW_ANSWER";
      case AlertType.newReport: return "NEW_REPORT";
      case AlertType.newFollow: return "NEW_FOLLOW";
      default: return "";
    }
  }
}

extension AlertEnumExtension on String {
  AlertType get convertAlertType {
    switch (this) {
      case "NEW_POST": return AlertType.newPost;
      case "NEW_ANSWER": return AlertType.newAnswer;
      case "NEW_REPORT": return AlertType.newReport;
      case "NEW_FOLLOW": return AlertType.newFollow;
      default: return AlertType.none;
    }
  }
}


class AlertController extends GetxController {
  RxList<AlertModel> userAlertList = <AlertModel>[].obs;
  RxBool isUserAlertListRefreshing = false.obs;

  RxBool hasNewAlert = false.obs;

  int refreshTime = 5;

  ApiProvider _apiProvider = Get.find<ApiProvider>();

  @override
  onInit() async {
    super.onInit();

    while (true) {
      try {
        await Future.delayed(
            Duration(seconds: 1),
                () async {
              if (refreshTime == 0) {
                await getHasNewAlertStatus();
                refreshTime = 15;
              } else {
                refreshTime = refreshTime - 1;
              }
            }
        );
      } catch (e) {}
    }
  }

  getUserAlertList() async {
    isUserAlertListRefreshing.value = true;
    userAlertList.value = (await _apiProvider.getUserAlertList())['content'];
    isUserAlertListRefreshing.value = false;

    userAlertList.forEach((element) => _apiProvider.changeReadStatusAlert(element.id!));

    hasNewAlert.value = false;
  }

  getHasNewAlertStatus() async {
    userAlertList.value = (await _apiProvider.getUserAlertList())['content'];
    userAlertList.forEach((element) {
      if (!element.isRead!) { hasNewAlert.value = true; }
    });
  }

  removeAllAlert() async {
    userAlertList.forEach((element) => _apiProvider.removeAlert(element.id!));

    getUserAlertList();
    Get.find<UserController>().showToast("모든 알림의 삭제를 진행하였습니다.");
  }
}
