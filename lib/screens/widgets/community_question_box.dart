import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/models/user.dart';
import 'package:flutter_recruit_asked/screens/community_comment.dart';
import 'package:flutter_recruit_asked/screens/widgets/questionbox_moreaction_dialog.dart';
import 'package:flutter_recruit_asked/screens/widgets/small_action_button.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controllers/question_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/question.dart';
import '../../themes/text_theme.dart';

class CommunityQuestionBox extends GetWidget<QuestionController> {
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
                                text: (' ' * 7) + question.content!,
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
            (question.imageLink!.isNotEmpty ?
              SizedBox(
                height: _displayHeight * 0.2,
                child: ClipRRect(
                  child: ExtendedImage.network(question.imageLink!),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ) : SizedBox()
            ),
            SizedBox(height: _displayHeight * 0.02),
            SizedBox(
              width: _displayWidth * 0.84,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(question.publicMode == QuestionPublicMode.anonymous ? "익명" : question.author!.name!, style: communityQuestionPerson),
                  SizedBox(width: 2),
                  Icon(Icons.circle, size: 2),
                  SizedBox(width: 2),
                  Text(controller.simpleDateFormat.format(question.date!), style: questionAnswerDate),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    late SmallActionButton likeBtn;
    bool isQuestionLike = false;
    controller.userLikeQuestionList.forEach((element) => isQuestionLike = element.id! == question.id!);
    if (isQuestionLike) {
      likeBtn = SmallActionButton(buttonType: SmallActionButtonType.unlike, clickAction: () => controller.unlikeQuestion(question.id!, question.questionType!));
    } else {
      likeBtn = SmallActionButton(buttonType: SmallActionButtonType.like, clickAction: () => controller.likeQuestion(question.id!, question.questionType!));
    }
    List<Widget> optionButton = [
      likeBtn,
      SmallActionButton(buttonType: SmallActionButtonType.comment, clickAction: () => Get.to(CommunityComment(question: question), transition: Transition.rightToLeft)),
    ];

    if (question.author == Get.find<UserController>().user.name) {
      optionButton.add(SmallActionButton(buttonType: SmallActionButtonType.remove, clickAction: () => controller.removeQuestion(question.id!, QuestionType.community)));
    }

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
                        builder: (_) => QuestionBoxMoreActionDialog(questionContentWidget: questionContentWidget, question: question)),
                    child: Icon(Icons.more_vert_rounded, color: grayOne)
                ),
              )
            ],
          ),
          SizedBox(height: _displayHeight * 0.025),
          Center(
            child: SizedBox(
              width: _displayWidth * (optionButton.length == 3 ? 0.75 : 0.55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: optionButton
              ),
            ),
          )
        ],
      ),
    );
  }
}