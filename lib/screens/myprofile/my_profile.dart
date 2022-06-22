import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/auth_controller.dart';
import 'package:flutter_recruit_asked/controllers/mainscreen_controller.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/screens/myprofile/change_profile.dart';
import 'package:flutter_recruit_asked/screens/myprofile/following_list.dart';
import 'package:flutter_recruit_asked/screens/myprofile/question_list.dart';
import 'package:flutter_recruit_asked/screens/widgets/simple_list_button.dart';
import 'package:flutter_recruit_asked/screens/widgets/profile_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

class MyProfile extends GetWidget<UserController> {
  MyProfile({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    AuthController _authController = Get.find<AuthController>();
    MainScreenController _mainScreenController = Get.find<MainScreenController>();


    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(width: _width),
                        Text("dohui_doch", style: appBarTitle),
                        Positioned(
                          right: _width * 0.075,
                          child: SvgPicture.asset(
                            "assets/images/icons/alert.svg",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: _height * 0.0225),
                    SizedBox(
                      width: _width * 0.85,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProfileWidget(user: controller.user, showShareBtn: false),
                          GestureDetector(
                              onTap: () => Get.to(ChangeProfile(), transition: Transition.rightToLeft),
                              child: SvgPicture.asset(
                                "assets/images/icons/pencil.svg",
                                color: Colors.black,
                                width: 24,
                              )
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: _height * 0.02),
                    Divider(color: grayFive, thickness: 1),
                    SimpleListButton(text: "내가 팔로우한 사람들", btnType: SimpleListButtonType.black, clickAction: () => _mainScreenController.showWindow = FollowingList()),
                    SimpleListButton(text: "내 질문 목록", btnType: SimpleListButtonType.black, clickAction: () => _mainScreenController.showWindow = QuestionList(questionType: QuestionListType.myQuestion)),
                    SimpleListButton(text: "내 저장 목록", btnType: SimpleListButtonType.black, clickAction: () => _mainScreenController.showWindow = QuestionList(questionType: QuestionListType.myBookmark)),
                    SimpleListButton(text: "로그아웃", btnType: SimpleListButtonType.red, clickAction: () => _authController.logOut()),
                  ],
                ),
              ],
            )
        )
      ),
    );
  }
}