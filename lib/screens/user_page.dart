import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/screens/widgets/custom_tabbar.dart';
import 'package:flutter_recruit_asked/screens/widgets/personal_question_box.dart';
import 'package:flutter_recruit_asked/screens/widgets/profile_widget.dart';
import 'package:flutter_recruit_asked/screens/widgets/purple_button.dart';
import 'package:flutter_recruit_asked/screens/widgets/sort_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/question_controller.dart';
import '../models/question.dart';
import '../models/user.dart';
import '../themes/color_theme.dart';
import '../themes/text_theme.dart';
import 'question_ask.dart';

class UserPage extends GetWidget<UserController> {
  UserModel user;
  bool isMyPage;
  UserPage({required this.user, required this.isMyPage});

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Obx(() {
            if (isMyPage) { user = controller.userModel.value; }

            return Stack(
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
                        Text(user.linkId!, style: appBarTitle),
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
                          ProfileWidget(user: user, showShareBtn: true),
                          Column(
                            children: [
                              (
                                !isMyPage ?
                                GestureDetector(
                                  onTap: () => controller.followOtherUser(user.id!),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_circle_outline_rounded, color: grayOne, size: 16),
                                      SizedBox(width: 4),
                                      Text("팔로우", style: profileFollowBtn)
                                    ],
                                  ),
                                ) : SizedBox()
                              ),
                              SizedBox(height: 12),
                              PurpleButton(
                                buttonMode: PurpleButtonMode.regular,
                                text: "질문하기",
                                clickAction: () => Get.to(AskQuestion(questionType: QuestionType.personal), transition: Transition.rightToLeft),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: CustomTabBar(
                      width: _width * 0.95,
                      height: _height * 0.675,
                      indicatorSizeMode: TabBarIndicatorSizeMode.text,
                      tabWindowsList: questionTabView(["답변완료 160", "새질문 16", "거절질문 6"])
                  ),
                )
              ],
            );
          })
        )
      ),
    );
  }

  List<CustomTabWindow> questionTabView(List tabTitleList) {
    List<CustomTabWindow> result = [];

    for (String title in tabTitleList) {
      result.add(
        CustomTabWindow(
          title: title,
          childWidget: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                right: _width * 0.05,
                child: SortButton(btnType: SortButtonType.latest)
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: _width * 0.875,
                  height: _height * 0.57,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return PersonalQuestionBox(
                            question: QuestionModel(
                                questionType: QuestionType.personal,
                                publicMode: QuestionPublicMode.anonymous,
                                questionStatus: title.contains("답변") ? QuestionStatus.answered : QuestionStatus.newQuestion,
                                content: "하이 반가워",
                                author: "윤지",
                                date: "2주 전"
                            ), index: index);
                      }
                  ),
                ),
              )
            ],
          )
        )
      );
    }

    return result;
  }
}