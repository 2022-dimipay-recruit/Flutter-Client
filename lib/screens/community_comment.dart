import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/models/comment.dart';
import 'package:flutter_recruit_asked/screens/widgets/community_question_box.dart';
import 'package:flutter_recruit_asked/screens/widgets/purple_button.dart';
import 'package:flutter_recruit_asked/screens/widgets/purple_switch.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/question_controller.dart';
import '../models/question.dart';
import '../themes/color_theme.dart';
import '../themes/text_theme.dart';

class CommunityComment extends GetWidget<QuestionController> {
  QuestionModel question;
  CommunityComment({required this.question});

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
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: _width),
                Text("질문하기", style: appBarTitle),
                Positioned(
                  left: _width * 0.075,
                  child: GestureDetector(onTap: () => Get.back(), child: Icon(Icons.arrow_back_ios_sharp, size: 24)),
                )
              ],
            ),
            Positioned(
              top: _height * 0.07,
              child: CommunityQuestionBox(question: question, index: 0)
            ),
            Positioned(
                top: _height * 0.235,
                left: _width * 0.06,
                child: SizedBox(
                  width: _width * 0.875,
                  height: _height * 0.57,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            commentBox(CommentModel(content: "반가워 댓글", author: "유도히", date: "1주 전")),
                            SizedBox(height: _height * 0.015),
                          ],
                        );
                      }
                  ),
                ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: _width,
                height: _height * 0.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 10,
                      spreadRadius: 10,
                      offset: Offset(0, -4)
                    )
                  ]
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(left: _width * 0.04, child: PurpleSwitch(optionList: ['익명', '공개'], nowValue: controller.commentMode)),
                    Positioned(
                      left: _width * 0.24,
                      child: SizedBox(
                        width: _width * 0.5,
                        child: TextField(
                          minLines: 1,
                          maxLines: 1,
                          controller: controller.answerTextController,
                          keyboardType: TextInputType.text,
                          style: communityCommentTextField,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: _height * 0.02),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0, style: BorderStyle.none,)),
                              hintText: "댓글 내용을 입력하세요",
                              hintStyle: communityCommentTextField.copyWith(color: grayFour)
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: _width * 0.04,
                      child: PurpleButton(
                        buttonMode: PurpleButtonMode.regular,
                        text: "등록",
                        clickAction: () {
                          //TODO 댓글 달기
                          Get.back();
                        }
                      )
                    )
                  ],
                )
              ),
            )
          ],
        ),
      )
    );
  }

  commentBox(CommentModel comment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Get.find<UserController>().getProfileWidget(Get.find<UserController>().user, _width, 0.03),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.author, style: questionAnswerPageAuthor),
                SizedBox(width: 4),
                Text(comment.date, style: questionAnswerPageDate)
              ],
            ),
            SizedBox(height: 4),
            Text(comment.content, style: questionAnswerPageContent),
          ],
        )
      ],
    );
  }
}