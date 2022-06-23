import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/auth_controller.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/screens/widgets/purple_button.dart';
import 'package:flutter_recruit_asked/screens/widgets/questionbox_moreaction_dialog.dart';
import 'package:flutter_recruit_asked/screens/widgets/small_action_button.dart';
import 'package:flutter_recruit_asked/screens/widgets/sort_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../themes/color_theme.dart';
import '../themes/text_theme.dart';
import 'ask_question.dart';

class Community extends StatelessWidget {
  Community({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;


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
                              onTap: () => Get.to(AskQuestion(askQuestionMode: AskQuestionMode.personal), transition: Transition.rightToLeft),
                              child: Text("자유롭게 글을 작성해보세요.", style: communityAskQuestion)
                            )
                          ],
                        ),
                        PurpleButton(
                          buttonMode: PurpleButtonMode.regular,
                          text: "질문하기",
                          clickAction: () => Get.to(AskQuestion(askQuestionMode: AskQuestionMode.personal), transition: Transition.rightToLeft),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: _height * 0.125,
                right: _width * 0.0675,
                child: SortButton(btnType: SortButtonType.latest)
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: _width * 0.875,
                  height: _height * 0.65,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return questionBox(context, index);
                      }
                  ),
                ),
              )
           ],
         )
       )
     )
    );
  }

  questionBox(BuildContext context, int index) {
    dynamic questionContentWidget = SizedBox(
      child: Hero(
        tag: "homeQuestionBox_$index",
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(width: _width, height: _height * 0.05),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: purpleOne
                  ),
                  child: Center(
                    child: Text("Q", style: questionCircleIcon),
                  ),
                ),
                Positioned(
                  top: -2.5,
                  child: SizedBox(
                    width: _width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            strutStyle: StrutStyle(fontSize: 16.0),
                            text: TextSpan(
                              text: (' ' * 7) + '디미고인 여러분 안녕하세요! 본 텍스트는 커뮤니티 UI 질문 위젯의 정상적인 작동을 테스트하기 위한 질문입니다.',
                              style: communityQuestionContent,
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                ),
              ],
            ),
            SizedBox(height: _height * 0.02),
            SizedBox(
              width: _width * 0.84,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("윤지", style: communityQuestionPerson),
                  SizedBox(width: 2),
                  Icon(Icons.circle, size: 2),
                  SizedBox(width: 2),
                  Text("2주 전", style: questionAnswerDate),
                ],
              ),
            ),
          ],
        ),
      ),
    );


    return Container(
      width: _width * 0.85,
      margin: EdgeInsets.only(bottom: _height * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              questionContentWidget,
              Positioned(
                right: _width * 0.025,
                bottom: 0,
                child: GestureDetector(
                    onTap: () => showDialog(
                        context: context,
                        builder: (_) => QuestionBoxMoreActionDialog(questionContentWidget: questionContentWidget)),
                    child: Icon(Icons.more_vert_rounded, color: grayOne)
                ),
              )
            ],
          ),
          SizedBox(height: _height * 0.025),
          Center(
            child: SizedBox(
              width: _width * 0.75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmallActionButton(buttonType: SmallActionButtonType.like, clickAction: () => print("좋아요")),
                  SmallActionButton(buttonType: SmallActionButtonType.comment, clickAction: () => print("댓글달기")),
                  SmallActionButton(buttonType: SmallActionButtonType.remove, clickAction: () => print("지우기")),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}