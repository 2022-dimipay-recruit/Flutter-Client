import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user.dart';

class UserController extends GetxController {
  final Rx<UserModel> _userModel = UserModel().obs;
  UserModel get user => _userModel.value;

  RxBool isAllowAlert = true.obs;
  RxInt userTardyAmount = 0.obs;

  set user(UserModel value) => _userModel.value = value;

  void clear() {
    _userModel.value = UserModel();
  }

  dynamic getProfileWidget(double _width) {
    if (user.profileImg == "") {
      return Icon(Icons.person_rounded, size: _width * 0.12);
    } else {
      return ExtendedImage.network(user.profileImg!, cache: true);
    }
  }

}
