import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/mainscreen_controller.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/screens/widgets/detail_list_button.dart';
import 'package:flutter_recruit_asked/screens/widgets/person_box.dart';
import 'package:get/get.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';
import 'change_profile_input_text.dart';

class FollowingList extends GetWidget<UserController> {
  FollowingList({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    MainScreenController _mainScreenController = Get.find<MainScreenController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(width: _width, height: _height),
            Text(controller.user.id!, style: appBarTitle),
            Positioned(
              left: _width * 0.075,
              child: GestureDetector(onTap: () => _mainScreenController.showWindow = _mainScreenController.bottomNavigationBarPages[3], child: Icon(Icons.arrow_back_ios_sharp, size: 24)),
            ),
            Positioned(
              top: _height * 0.07,
              left: _width * 0.075,
              child: Text("팔로잉 목록", style: followingListTitle)
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: _width * 0.875,
                height: _height * 0.73,
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return PersonBox(boxType: PersonBoxType.following, user: controller.user);
                    }
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}