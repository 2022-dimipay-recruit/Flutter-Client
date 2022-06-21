import 'package:circular_profile_avatar/circular_profile_avatar.dart';
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

  dynamic getProfileWidget(double _width, double radiusRatio) {
    dynamic imageWidget;
    if (user.profileImg == null || user.profileImg == "") {
      imageWidget = Container(
        height: _width * 0.17,
        width: _width * 0.17,
        decoration: BoxDecoration(
          color: purpleOne,
          borderRadius: BorderRadius.circular(150)
        ),
        child: Icon(Icons.person_rounded, color: Colors.white, size: _width * 0.08),
      );
    } else {
      imageWidget = ExtendedImage.network(user.profileImg!, cache: true);
    }

    return CircularProfileAvatar(
      '',
      child: imageWidget,
      radius: _width * radiusRatio,
      backgroundColor: Colors.transparent,
      cacheImage: true,
    );
  }

}
