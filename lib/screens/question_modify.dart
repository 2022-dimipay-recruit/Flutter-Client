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

class ModifyQuestion extends GetWidget<QuestionController> {
  late QuestionModel question;
  ModifyQuestion({required this.question});

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    UserController _userController = Get.find<UserController>();

    controller.contentTextController.text = question.content!;


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
                  Text("질문 수정하기", style: appBarTitle),
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
                      children: [
                        _userController.getProfileWidget(_userController.user, _width, 0.05),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_userController.user.name!, style: askQuestionAuthor.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: _height * 0.01),
                    SizedBox(
                      width: _width * 0.9,
                      height: (_height * 0.7),
                      child: TextField(
                        minLines: 1,
                        maxLines: null,
                        controller: controller.contentTextController,
                        keyboardType: TextInputType.multiline,
                        style: askQuestionContent,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: _height * 0.02),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0, style: BorderStyle.none,)),
                            hintText: "수정할 내용을 입력해주세요.",
                            hintStyle: askQuestionContent.copyWith(color: grayOne)
                        ),
                      ),
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
                  text: "수정하기",
                  clickAction: () => controller.modifyQuestion(question.id!, question.questionType!)
              ),
            )
          ],
        ),
      )
    );
  }
}