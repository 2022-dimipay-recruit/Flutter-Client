import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/screens/widgets/purple_button.dart';
import 'package:flutter_recruit_asked/screens/widgets/purple_switch.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/question_controller.dart';
import '../models/question.dart';
import '../themes/color_theme.dart';
import '../themes/text_theme.dart';

class QuestionAnswer extends GetWidget<QuestionController> {
  late QuestionModel question;
  QuestionAnswer({required this.question});

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    UserController _userController = Get.find<UserController>();


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(width: _width, height: _height),
            Positioned(
              top: _height * 0.01,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(width: _width),
                  Text("답하기", style: appBarTitle),
                  Positioned(
                    left: _width * 0.075,
                    child: GestureDetector(onTap: () => Get.back(), child: Icon(Icons.arrow_back_ios_sharp, size: 24)),
                  )
                ],
              ),
            ),
            Positioned(
              top: _height * 0.07,
              left: _width * 0.06,
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _userController.getProfileWidget(Get.find<UserController>().user, _width, 0.03),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(question.author!.name!, style: questionAnswerPageAuthor),
                                SizedBox(width: 4),
                                Text(question.date!.toString(), style: questionAnswerPageDate)
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(question.content!, style: questionAnswerPageContent),
                            SizedBox(height: 10),
                            Text("${question.author!.name!} 님 질문에 답변을 작성해주세요", style: questionAnswerPageHelpMsg)
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: _height * 0.0175),
                    Row(
                      children: [
                        _userController.getProfileWidget(Get.find<UserController>().user, _width, 0.03),
                        SizedBox(width: _width * 0.04),
                        SizedBox(
                          width: _width * 0.78,
                          child: TextField(
                            minLines: 1,
                            maxLines: null,
                            controller: controller.answerTextController,
                            keyboardType: TextInputType.text,
                            style: questionAnswerPageTextField,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: _height * 0.02),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0, style: BorderStyle.none,)),
                                hintText: "답변을 입력하세요",
                                hintStyle: questionAnswerPageTextField.copyWith(color: grayTwo)
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ),
            Positioned(
              bottom: _height * 0.02,
              right: _width * 0.075,
              child: PurpleButton(
                  buttonMode: PurpleButtonMode.regular,
                  text: "답변하기",
                  clickAction: () => controller.commentToQuestion(question.id!, controller.answerTextController.text, false, question.questionType!)
              )
            )
          ],
        ),
      )
    );
  }
}