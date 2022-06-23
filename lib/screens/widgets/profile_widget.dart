import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/models/user.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../themes/text_theme.dart';

class ProfileWidget extends StatelessWidget {
  final UserModel user;
  final bool showShareBtn;
  ProfileWidget({required this.user, required this.showShareBtn});

  @override
  Widget build(BuildContext context) {
    final double _displayHeight = MediaQuery.of(context).size.height;
    final double _displayWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Get.find<UserController>().getProfileWidget(Get.find<UserController>().user, _displayWidth, 0.105),
        SizedBox(width: _displayWidth * 0.05),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("유도히", style: profileNickname),
                SizedBox(width: _displayWidth * 0.0125),
                (showShareBtn ?
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: purpleOne
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/images/icons/share.svg",
                        color: Colors.white,
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ) : SizedBox()),
              ],
            ),
            SizedBox(height: 4),
            Text("팔로워 213", style: profileFollwer),
            SizedBox(height: 2),
            Text("반가워요 여러분", style: profileIntroduce),
          ],
        )
      ],
    );
  }
}