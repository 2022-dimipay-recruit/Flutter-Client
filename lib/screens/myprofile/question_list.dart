import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:get/get.dart';

import '../../controllers/mainscreen_controller.dart';
import '../../controllers/question_controller.dart';
import '../../models/question.dart';
import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';
import '../widgets/community_question_box.dart';
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
    QuestionController _questionController = Get.find<QuestionController>();

    questionType == QuestionListType.myQuestion ?
      _questionController.getUserAskQuestionList() :
      _questionController.getUserBookmarkQuestionList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children:  [
            SizedBox(width: _width, height: _height),
            Positioned(top: _height * 0.01, child: Text("${questionType.getStr} 목록", style: appBarTitle)),
            Positioned(
              top: _height * 0.01,
              left: _width * 0.075,
              child: GestureDetector(onTap: () => _mainScreenController.showWindow = _mainScreenController.bottomNavigationBarPages[3], child: Icon(Icons.arrow_back_ios_sharp, size: 24)),
            ),
            Positioned(
              bottom: 0,
              child: Obx(() {
                if (!_questionController.isUserBookmarkQuestionListRefreshing.value || !_questionController.isUserAskQuestionListRefreshing.value) {
                  List<QuestionModel> responseData =
                  questionType == QuestionListType.myQuestion ?
                    _questionController.userAskQuestionList :
                    _questionController.userBookmarkQuestionList;

                  Map questionList = {};
                  for (QuestionType tabQuestionType in QuestionType.values) {
                    questionList.addAll({tabQuestionType: <QuestionModel>[]});
                  }

                  responseData.forEach((question) => (questionList[question.questionType!] as List<QuestionModel>).add(question));

                  List tabViewTitleList = [];
                  questionList.forEach((key, value) => tabViewTitleList.add((key as QuestionType).convertStr));


                  return CustomTabBar(
                      width: _width,
                      height: _height * 0.78,
                      indicatorSizeMode: TabBarIndicatorSizeMode.both,
                      tabWindowsList: questionTabView(
                        tabViewTitleList,
                        questionList,
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
              }),
            )
          ],
        ),
      )
    );
  }

  List<CustomTabWindow> questionTabView(List tabTitleList, Map questionList) {
    List<CustomTabWindow> result = [];

    for (String title in tabTitleList) {
      List tabQuestionList = questionList[title.convertQuestionType];

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
                          itemCount: tabQuestionList.length,
                          itemBuilder: (context, index) {
                            return (title.convertQuestionType == QuestionType.personal ?
                                PersonalQuestionBox(question: tabQuestionList[index], index: index)
                              : CommunityQuestionBox(question: tabQuestionList[index], index: index)
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