import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/auth_controller.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/screens/widgets/community_question_box.dart';
import 'package:flutter_recruit_asked/screens/widgets/purple_button.dart';
import 'package:flutter_recruit_asked/screens/widgets/questionbox_moreaction_dialog.dart';
import 'package:flutter_recruit_asked/screens/widgets/small_action_button.dart';
import 'package:flutter_recruit_asked/screens/widgets/sort_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/question_controller.dart';
import '../models/question.dart';
import '../themes/color_theme.dart';
import '../themes/text_theme.dart';
import 'question_ask.dart';

class Community extends GetWidget<QuestionController> {
  Community({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    controller.getCommunityQuestionList();


    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(width: _width, height: _height),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(width: _width),
                      Text("커뮤니티", style: appBarTitle),
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
                    width: _width * 0.875,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Get.find<UserController>().getProfileWidget(Get.find<UserController>().user, _width, 0.061),
                            SizedBox(width: _width * 0.03),
                            GestureDetector(
                              onTap: () => Get.to(AskQuestion(questionType: QuestionType.community), transition: Transition.rightToLeft),
                              child: Text("자유롭게 글을 작성해보세요.", style: communityAskQuestion)
                            )
                          ],
                        ),
                        PurpleButton(
                          buttonMode: PurpleButtonMode.regular,
                          text: "질문하기",
                          clickAction: () => Get.to(AskQuestion(questionType: QuestionType.community), transition: Transition.rightToLeft),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: _height * 0.125,
                right: _width * 0.0675,
                child: SortButton(btnType: controller.sortType, questionType: QuestionType.community)
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: _width * 0.875,
                  height: _height * 0.65,
                  child: Obx(() {
                    if (!controller.isCommunityQuestionListRefreshing.value) {
                      List<QuestionModel> responseData = controller.communityQuestionList;

                      if (controller.sortType.value == SortButtonType.oldest) {
                        responseData = responseData..sort((a,b) => a.date.toString().compareTo(b.date.toString()));
                      } else {
                        responseData = responseData..sort((b,a) => a.date.toString().compareTo(b.date.toString()));
                      }

                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: responseData.length,
                          itemBuilder: (context, index) {
                            return CommunityQuestionBox(question: responseData[index], index: index);
                          }
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
                ),
              )
           ],
         )
       )
     )
    );
  }
}