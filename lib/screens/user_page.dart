import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/mainscreen_controller.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/screens/widgets/alert_button.dart';
import 'package:flutter_recruit_asked/screens/widgets/custom_tabbar.dart';
import 'package:flutter_recruit_asked/screens/widgets/follow_button.dart';
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
  UserPage({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    QuestionController _questionController = Get.find<QuestionController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Obx(() {
            Rx<UserModel> user = Get.find<MainScreenController>().userInUserPage;
            bool isMyPage = controller.user == UserModel() || (controller.user == user.value);

            _questionController.getUserPersonalQuestionList(user.value.id!);

            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: _height * 0.01,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(width: _width),
                      Text(user.value.linkId!, style: appBarTitle),
                      Positioned(
                        right: _width * 0.075,
                        child: AlertButton(),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: _height * 0.06),
                    SizedBox(
                      width: _width * 0.85,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProfileWidget(user: user, showShareBtn: true),
                          Column(
                            children: [
                              !isMyPage ? FollowButton(btnType: controller.followBtnType, userId: user.value.id!) : SizedBox(),
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

                    if (!isMyPage) { tabViewTitleList.removeRange(1, 3); }

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
                  width: _width * 0.84,
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