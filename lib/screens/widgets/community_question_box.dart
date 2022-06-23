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

class CommunityQuestionBox extends StatelessWidget {
  final QuestionModel question;
  final int index;
  CommunityQuestionBox({required this.question, required this.index});

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
            Stack(
              children: [
                SizedBox(width: _displayWidth, height: _displayHeight * 0.05),
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
                      width: _displayWidth * 0.8,
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
            SizedBox(height: _displayHeight * 0.02),
            SizedBox(
              width: _displayWidth * 0.84,
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
      width: _displayWidth * 0.85,
      margin: EdgeInsets.only(bottom: _displayHeight * 0.05),
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