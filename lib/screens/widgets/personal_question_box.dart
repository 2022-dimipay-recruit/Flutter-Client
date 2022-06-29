import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/models/comment.dart';
import 'package:flutter_recruit_asked/models/user.dart';
import 'package:flutter_recruit_asked/screens/question_answer.dart';
import 'package:flutter_recruit_asked/screens/widgets/questionbox_moreaction_dialog.dart';
import 'package:flutter_recruit_asked/screens/widgets/small_action_button.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controllers/question_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/question.dart';
import '../../themes/text_theme.dart';
import '../question_modify.dart';

class PersonalQuestionBox extends GetWidget<QuestionController> {
  final QuestionModel question;
  final int index;
  PersonalQuestionBox({required this.question, required this.index});

  @override
  Widget build(BuildContext context) {
    final double _displayHeight = MediaQuery.of(context).size.height;
    final double _displayWidth = MediaQuery.of(context).size.width;

    late CommentModel? questionAnswer;
    if (question.questionStatus! == QuestionStatus.answered) {
      questionAnswer = controller.personalQuestionAnswerList[question.id!];
    }

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
                    Text(question.publicMode! == QuestionPublicMode.anonymous ? question.publicMode!.convertStr : question.author!.name!, style: questionType),
                    SizedBox(height: 4),
                    Text(question.content!, style: questionContent),
                    SizedBox(height: 6),
                    (question.imageLink!.isNotEmpty ?
                      GestureDetector(
                        onTap: () => showDialog(context: context, builder: (_) => Dialog(child: SizedBox(width: _displayWidth * 0.9, child: ExtendedImage.network(question.imageLink!)))),
                        child: SizedBox(
                          height: _displayHeight * 0.2,
                          child: ClipRRect(
                            child: ExtendedImage.network(question.imageLink!),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ) : SizedBox()
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: _displayHeight * (question.questionStatus == QuestionStatus.answered ? 0.02 : 0)),
            (question.questionStatus == QuestionStatus.answered ?
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
                            Text(questionAnswer!.author!.name!, style: questionAnswerPerson),
                            SizedBox(width: 2),
                            Text(controller.simpleDateFormat.format(questionAnswer.date!), style: questionAnswerDate),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(questionAnswer.content!, style: questionAnswerContent),
                      ],
                    )
                  ],
                ),
              ) : SizedBox()
            ),
          ],
        ),
      ),
    );

    bool isMyQuestion = question.author!.id! == Get.find<UserController>().user.id!;
    List<Widget> optionButton = [];
    if (isMyQuestion) { optionButton.add(SmallActionButton(buttonType: SmallActionButtonType.remove, clickAction: () => controller.removeQuestion(question.id!, QuestionType.personal))); }

    if (question.questionStatus == QuestionStatus.answered) {
      late SmallActionButton likeBtn;
      bool isQuestionLike = false;
      controller.userLikeQuestionList.forEach((element) => isQuestionLike = element.id! == question.id!);
      if (isQuestionLike) {
        likeBtn = SmallActionButton(buttonType: SmallActionButtonType.unlike, clickAction: () => controller.unlikeQuestion(question.id!, question.questionType!));
      } else {
        likeBtn = SmallActionButton(buttonType: SmallActionButtonType.like, clickAction: () => controller.likeQuestion(question.id!, question.questionType!));
      }

      optionButton.insert(0, likeBtn);
      if (isMyQuestion) { optionButton.insert(1, SmallActionButton(buttonType: SmallActionButtonType.modify, clickAction: () => Get.to(ModifyQuestion(question: question), transition: Transition.rightToLeft))); }
    } else {
      optionButton.insert(0, SmallActionButton(buttonType: SmallActionButtonType.answer, clickAction: () => Get.to(QuestionAnswer(question: question), transition: Transition.rightToLeft)));
      if (question.questionStatus == QuestionStatus.newQuestion) {
        optionButton.insert(1, SmallActionButton(buttonType: SmallActionButtonType.reject, clickAction: () => controller.rejectQuestion(question.id!, question.questionType!)));
      }
    }

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
                        builder: (_) => QuestionBoxMoreActionDialog(questionContentWidget: questionContentWidget, question: question)),
                    child: Icon(Icons.more_vert_rounded, color: grayOne)
                ),
              )
            ],
          ),
          SizedBox(height: _displayHeight * 0.025),
          Center(
            child: SizedBox(
              width: _displayWidth * (optionButton.length == 3 ? 0.75 : (optionButton.length == 2 ? 0.55 : 0.15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: optionButton,
              ),
            ),
          )
        ],
      ),
    );
  }
}