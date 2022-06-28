import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/models/comment.dart';
import 'package:flutter_recruit_asked/screens/widgets/community_question_box.dart';
import 'package:flutter_recruit_asked/screens/widgets/purple_button.dart';
import 'package:flutter_recruit_asked/screens/widgets/purple_switch.dart';
import 'package:get/get.dart';

import '../controllers/question_controller.dart';
import '../models/question.dart';
import '../models/user.dart';
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

    controller.getCommunityQuestionCommentList(question.id!);


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
                Text("댓글 남기기", style: appBarTitle),
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
                bottom: _height * 0.08,
                child:  Obx(() {
                  if (!controller.isCommunityCommentListRefreshing.value) {
                    List<CommentModel> responseData = controller.communityCommentList;

                    return SizedBox(
                      width: _width * 0.875,
                      height: _height * 0.59,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: responseData.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                commentBox(responseData[index]),
                                SizedBox(height: _height * 0.015),
                              ],
                            );
                          }
                      ),
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
            Positioned(
              bottom: 0,
              child: Container(
                width: _width,
                height: _height * 0.08,
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
                        clickAction:
                            () => controller.commentToQuestion(
                                question.id!,
                                controller.answerTextController.text,
                                (controller.commentMode.value.convertQuestionPublicMode == QuestionPublicMode.anonymous),
                                question.questionType!,
                            )
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
    print(comment.toJson());
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Get.find<UserController>().getProfileWidget(comment.isAnony! ? UserModel() : comment.author!, _width, 0.03),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.isAnony! ? "익명" : comment.author!.name!, style: questionAnswerPageAuthor),
                SizedBox(width: 4),
                Text(controller.simpleDateFormat.format(comment.date!), style: questionAnswerPageDate)
              ],
            ),
            SizedBox(height: 4),
            Text(comment.content!, style: questionAnswerPageContent),
          ],
        )
      ],
    );
  }
}