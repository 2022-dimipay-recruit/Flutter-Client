import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/mainscreen_controller.dart';
import 'package:flutter_recruit_asked/models/user.dart';
import 'package:flutter_recruit_asked/screens/widgets/purple_button.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../themes/text_theme.dart';

class FollowingPersonBox extends StatelessWidget {
  final UserModel user;
  FollowingPersonBox({required this.user});

  @override
  Widget build(BuildContext context) {
    final double _displayHeight = MediaQuery.of(context).size.height;
    final double _displayWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: _displayWidth * 0.9,
      height: _displayHeight * 0.09,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Get.find<UserController>().getProfileWidget(user, _displayWidth, 0.07),
              SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.linkId!, style: personBoxTitle),
                  SizedBox(height: 4),
                  Text(user.name!, style: personBoxSubTitle.copyWith(color: grayOne)),
                ],
              )
            ],
          ),
          PurpleButton(buttonMode: PurpleButtonMode.regular, text: "보러가기", clickAction: () => Get.find<MainScreenController>().showUserWindow(user))
        ],
      )
    );
  }
}