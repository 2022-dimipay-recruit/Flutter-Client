import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/models/user.dart';
import 'package:flutter_recruit_asked/screens/widgets/purple_button.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../themes/text_theme.dart';

enum PersonBoxType {
  search,
  following
}

class PersonBox extends StatelessWidget {
  final PersonBoxType boxType;
  final UserModel user;
  PersonBox({required this.boxType, required this.user});

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
              CircularProfileAvatar(
                '',
                child: Get.find<UserController>().getProfileImg(_displayWidth),
                radius: _displayWidth * 0.07,
                backgroundColor: Colors.transparent,
                cacheImage: true,
              ),
              SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(boxType == PersonBoxType.search ? user.name! : user.id!, style: personBoxTitle),
                  SizedBox(height: 4),
                  Text("팔로워 213", style: personBoxSubTitle.copyWith(color: (boxType == PersonBoxType.search ? Colors.black : grayOne))),
                ],
              )
            ],
          ),
          (
            boxType == PersonBoxType.following ?
            PurpleButton(text: "팔로잉", clickAction: () => print("CLick"))
            : SizedBox()
          )
        ],
      )
    );
  }
}