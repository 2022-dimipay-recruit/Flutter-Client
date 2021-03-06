import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/question_controller.dart';
import 'package:flutter_recruit_asked/screens/widgets/purple_button.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../models/question.dart';
import '../../themes/text_theme.dart';
import 'big_action_button.dart';

class QuestionBoxMoreActionDialog extends GetWidget<QuestionController> {
  final dynamic questionContentWidget;
  QuestionModel question;
  QuestionBoxMoreActionDialog({required this.questionContentWidget, required this.question});

  late double _displayHeight, _displayWidth;

  @override
  Widget build(BuildContext context) {
    _displayHeight = MediaQuery.of(context).size.height;
    _displayWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: _displayWidth * 0.9,
        height: _displayHeight * (0.43 + (question.imageLink! != "" ? (0.175 + (question.questionType == QuestionType.personal ? 0.04 : 0)) : 0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                alignment: FractionalOffset.center,
                width: _displayWidth * 0.923,
                height: _displayHeight * (0.2 + (question.imageLink! != "" ? (0.175 + (question.questionType == QuestionType.personal ? 0.04 : 0)) : 0)),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: questionContentWidget
            ),
            SizedBox(height: _displayHeight * 0.0225),
            BigActionButton(
              buttonType: BigActionButtonType.share,
              clickAction: () => controller.shareQuestion(question),
            ),
            SizedBox(height: _displayHeight * 0.0125),
            BigActionButton(
              buttonType: BigActionButtonType.bookmark,
              clickAction: () => controller.bookmarkQuestion(question.id!, question.questionType!),
            ),
            SizedBox(height: _displayHeight * 0.0125),
            BigActionButton(
              buttonType: BigActionButtonType.report,
              clickAction: () => showDialog(
                context: context,
                builder: (_) => reportOptionDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  reportOptionDialog(BuildContext context) {
    List reportOptionList = [
      "????????? ?????? ????????? ??????",
      "???????????? ?????? ??????",
      "?????? ?????? ?????? ??????",
      "?????? ??? ?????? ?????? ??????",
      "????????? ?????? ??? ????????????, ???????????? ???",
      "??????, ????????? ?????? ??? ????????? ??????",
      "???????????? ?????? ??? ???????????? ?????? ???"
    ];
    RxMap optionStatus = {}.obs;
    String nowChoiceReason = "";
    reportOptionList.forEach((element) => optionStatus.addAll({element: false}));

    reportOptionWidget(String text) => Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() => GestureDetector(
          onTap: () {
            optionStatus.forEach((key, value) => optionStatus[key] = false);
            optionStatus[text] = !optionStatus[text];
            nowChoiceReason = text;
          },
          child: SvgPicture.asset(
            "assets/images/icons/checkbox.svg",
            width: 24,
            color: optionStatus[text] == true ? purpleOne : grayThree,
          ),
        )),
        SizedBox(width: 16),
        Text(text, style: reportOptionDialogOption),
      ],
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: _displayWidth * 0.9,
        height: _displayHeight * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("?????? ??????", style: reportOptionDialogTitle),
            SizedBox(height: _displayHeight * 0.02),
            Container(
              alignment: FractionalOffset.center,
              width: _displayWidth * 0.923,
              height: _displayHeight * 0.5125,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: _displayHeight * 0.01),
                  SizedBox(
                    height: _displayHeight * 0.4,
                    child: ListView.builder(
                        itemCount: reportOptionList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              reportOptionWidget(reportOptionList[index]),
                              SizedBox(height: _displayHeight * 0.03),
                            ],
                          );
                        }
                    ),
                  ),
                  SizedBox(height: _displayHeight * 0.01),
                  PurpleButton(
                    buttonMode: PurpleButtonMode.regular,
                    text: "????????????",
                    clickAction: () => controller.reportQuestion(
                      question.id!,
                      question.questionType!,
                      nowChoiceReason,
                      context,
                      reportSuccessDialog()
                    )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  reportSuccessDialog() {
    return Dialog(
      child: Container(
        width: _displayWidth * 0.7,
        height: _displayHeight * 0.335,
        decoration: BoxDecoration(),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: _displayHeight * 0.03,
              child: Column(
                children: [
                  Text("?????? ??????", style: reportSuccessDialogTitle),
                  SizedBox(height: _displayHeight * 0.025),
                  Text(
                    "?????? ????????? ??????????????? ?????????????????????.\n\n????????? ??? ??????????????? ???????????? ????????????\n?????? ???????????? ???????????????.\n\n??????????????? ????????????\n????????? ????????? ??????????????? ?????????????????????.",
                    textAlign: TextAlign.center,
                    style: reportSuccessDialogContent,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: GestureDetector(
                onTap: () { Get.back(); Get.back(); },
                child: Container(
                  width: _displayWidth * 0.72,
                  height: _displayHeight * 0.06,
                  decoration: BoxDecoration(
                    color: purpleOne,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))
                  ),
                  child: Center(child: Text("??????", style: reportSuccessDialogContent.copyWith(color: Colors.white))),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}