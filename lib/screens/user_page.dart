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

    QuestionController _questionController = Get.find<QuestionController>();

    _questionController.getUserPersonalQuestionList();

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
                  child: Obx(() {
                    if (!_questionController.isPersonalQuestionListRefreshing.value) {
                    List<QuestionModel> responseData = _questionController.personalQuestionList;

                    Map questionList = {};
                    for (QuestionStatus tabStatus in QuestionStatus.values) {
                      questionList.addAll({tabStatus: <QuestionModel>[]});
                    }

                    responseData.forEach((question) => (questionList[question.questionStatus!] as List<QuestionModel>).add(question));

                    for (QuestionStatus tabStatus in QuestionStatus.values) {
                      if (_questionController.sortType.value == SortButtonType.oldest) {
                        questionList[tabStatus] = questionList[tabStatus]..sort((a,b) => a.date.toString().compareTo(b.date.toString()));
                      } else {
                        questionList[tabStatus] = questionList[tabStatus]..sort((b,a) => a.date.toString().compareTo(b.date.toString()));
                      }
                    }
                    
                    List tabViewTitleList = [];
                    questionList.forEach((key, value) => tabViewTitleList.add("${(key as QuestionStatus).convertStr} ${value.length}"));

                    return CustomTabBar(
                        width: _width * 0.95,
                        height: _height * 0.675,
                        indicatorSizeMode: TabBarIndicatorSizeMode.text,
                        tabWindowsList: questionTabView(
                          tabViewTitleList,
                          questionList,
                          _questionController
                        )
                    );
                    } else { //데이터를 불러오는 중
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(width: _width, height: _height * 0.87),
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    }
                  })
                )
              ],
            );
          })
        )
      ),
    );
  }

  List<CustomTabWindow> questionTabView(List tabTitleList, Map questionList, QuestionController _questionController) {
    List<CustomTabWindow> result = [];

    for (String title in tabTitleList) {
      List tabQuestionList = questionList[title.substring(0, title.lastIndexOf(" ")).convertQuestionStatus];

      result.add(
        CustomTabWindow(
          title: title,
          childWidget: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                right: _width * 0.05,
                child: SortButton(btnType: _questionController.sortType, questionType: QuestionType.personal),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: _width * 0.875,
                  height: _height * 0.57,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: tabQuestionList.length,
                      itemBuilder: (context, index) {
                        return PersonalQuestionBox(question: tabQuestionList[index], index: index);
                      }
                  )
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