import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:get/get.dart';

import '../../controllers/mainscreen_controller.dart';
import '../../models/question.dart';
import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';
import '../widgets/custom_tabbar.dart';
import '../widgets/personal_question_box.dart';

enum QuestionListType {
  myQuestion,
  myBookmark
}

extension QuestionListTypeExtension on QuestionListType {
  String get getStr {
    switch (this) {
      case QuestionListType.myQuestion: return "질문";
      case QuestionListType.myBookmark: return "저장";
      default: return "";
    }
  }
}

class QuestionList extends GetWidget<UserController> {
  final QuestionListType questionType;
  QuestionList({required this.questionType});

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
          children:  [
            SizedBox(width: _width, height: _height),
            Text("${questionType.getStr} 목록", style: appBarTitle),
            Positioned(
              left: _width * 0.075,
              child: GestureDetector(onTap: () => _mainScreenController.showWindow = _mainScreenController.bottomNavigationBarPages[3], child: Icon(Icons.arrow_back_ios_sharp, size: 24)),
            ),
            Positioned(
              bottom: 0,
              child: CustomTabBar(
                  width: _width,
                  height: _height * 0.78,
                  indicatorSizeMode: TabBarIndicatorSizeMode.both,
                  tabWindowsList: questionTabView(["개인 활동", "커뮤니티"])
              ),
            )
          ],
        ),
      )
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
                    bottom: 0,
                    child: SizedBox(
                      width: _width * 0.875,
                      height: _height * 0.7,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return PersonalQuestionBox(
                                question: QuestionModel(
                                    questionType: title.contains("커뮤니티") ? QuestionType.community : QuestionType.personal,
                                    publicMode: QuestionPublicMode.anonymous,
                                    content: "하이 반가워",
                                    author: "윤지",
                                    date: "2주 전"
                                ),
                                index: index
                            );
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