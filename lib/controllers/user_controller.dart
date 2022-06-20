import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:get/get.dart';

import '../models/user.dart';

class UserController extends GetxController {
  final Rx<UserModel> _userModel = UserModel().obs;
  UserModel get user => _userModel.value;

  set user(UserModel value) => _userModel.value = value;

  void clear() {
    _userModel.value = UserModel();
  }

  dynamic getProfileImg(double _width) {
    if (user.profileImg == null || user.profileImg == "") {
      return Container(
        height: _width * 0.17,
        width: _width * 0.17,
        decoration: BoxDecoration(
          color: purpleOne,
          borderRadius: BorderRadius.circular(150)
        ),
        child: Icon(Icons.person_rounded, size: _width * 0.12),
      );
    } else {
      return ExtendedImage.network(user.profileImg!, cache: true);
    }
  }

}
