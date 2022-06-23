import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/models/user.dart';
import 'package:flutter_recruit_asked/screens/widgets/questionbox_moreaction_dialog.dart';
import 'package:flutter_recruit_asked/screens/widgets/small_action_button.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../models/question.dart';
import '../../themes/text_theme.dart';

class PersonalQuestionBox extends StatelessWidget {
  final QuestionModel question;
  final int index;
  PersonalQuestionBox({required this.question, required this.index});

  @override
  Widget build(BuildContext context) {
    final double _displayHeight = MediaQuery.of(context).size.height;
    final double _displayWidth = MediaQuery.of(context).size.width;

    dynamic questionContentWidget = SizedBox(
      child: Hero(
        tag: "homeQuestionBox_$index",
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(question.publicMode.convertStr, style: questionType),
                    SizedBox(height: 4),
                    Text(question.content, style: questionContent),
                  ],
                )
              ],
            ),
            SizedBox(height: _displayHeight * 0.02),
            SizedBox(
              width: _displayWidth * 0.84,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Get.find<UserController>().getProfileWidget(Get.find<UserController>().user, _displayWidth, 0.061),
                  SizedBox(width: _displayWidth * 0.03),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(question.author, style: questionAnswerPerson),
                          SizedBox(width: 2),
                          Text(question.date, style: questionAnswerDate),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text("메롱이다 메롱", style: questionAnswerContent)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      width: _displayWidth * 0.85,
      margin: EdgeInsets.only(bottom: _displayHeight * 0.0425),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              questionContentWidget,
              Positioned(
                right: _displayWidth * 0.025,
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
          SizedBox(height: _displayHeight * 0.025),
          Center(
            child: SizedBox(
              width: _displayWidth * 0.75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmallActionButton(buttonType: SmallActionButtonType.like, clickAction: () => print("좋아요")),
                  SmallActionButton(buttonType: SmallActionButtonType.modify, clickAction: () => print("수정")),
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