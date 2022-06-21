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
import '../themes/color_theme.dart';
import '../themes/text_theme.dart';

enum AskQuestionMode {
  personal,
  community
}

class AskQuestion extends GetWidget<QuestionController> {
  late AskQuestionMode askQuestionMode;
  AskQuestion({required this.askQuestionMode});

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    UserController _userController = Get.find<UserController>();


    return Scaffold(
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
              left: _width * 0.06,
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircularProfileAvatar(
                          '',
                          child: Get.find<UserController>().getProfileImg(_width),
                          radius: _width * 0.061,
                          backgroundColor: Colors.transparent,
                          cacheImage: true,
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("윤지", style: askQuestionAuthor),
                            SizedBox(height: 4),
                            PurpleSwitch(optionList: ['익명', '공개'], nowValue: controller.questionMode)
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: _height * 0.01),
                    SizedBox(
                      width: _width * 0.9,
                      child: TextField(
                        minLines: 1,
                        maxLines: 1,
                        controller: controller.titleTextController,
                        keyboardType: TextInputType.text,
                        style: askQuestionContent,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: _height * 0.02),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0, style: BorderStyle.none,)),
                          hintText: "제목 입력 (선택)",
                          hintStyle: askQuestionContent.copyWith(color: grayOne)
                        ),
                      ),
                    ),
                    Obx(() => SizedBox(
                      width: _width * 0.9,
                      height: (_height * (controller.questionImageFile.value!.path == "" ? 0.7 : 0.45)),
                      child: TextField(
                        minLines: 1,
                        maxLines: null,
                        controller: controller.contentTextController,
                        keyboardType: TextInputType.multiline,
                        style: askQuestionContent,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: _height * 0.02),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0, style: BorderStyle.none,)),
                          hintText: "질문을 입력해주세요.",
                          hintStyle: askQuestionContent.copyWith(color: grayOne)
                        ),
                      ),
                  ))
                  ],
                ),
              )
            ),
            Positioned(
              bottom: _height * 0.1,
              child: Obx(() {
                try {
                  return controller.questionImageFile.value!.path == "" ?
                    SizedBox() :
                    SizedBox(
                      height: _height * 0.2,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(height: _height * 0.2),
                          ClipRRect(
                            child: ExtendedImage.file(File(controller.questionImageFile.value!.path)),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          GestureDetector(
                            onTap: () => controller.questionImageFile.value = XFile(""),
                            child: Icon(Icons.close_rounded, color: Colors.white)
                          ),
                        ],
                      ),
                    );
                } catch (e) { return SizedBox(); }
              })
            ),
            Positioned(
              bottom: _height * 0.02,
              child: SizedBox(
                width: _width * 0.875,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _width * 0.18,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => controller.getImageFromDevice(ImageSource.camera),
                            child: Icon(Icons.camera_alt_rounded, color: purpleOne, size: 24)
                          ),
                          GestureDetector(
                              onTap: () => controller.getImageFromDevice(ImageSource.gallery),
                              child: SvgPicture.asset(
                                "assets/images/icons/gallery.svg",
                                color: purpleOne,
                                width: 24,
                              )
                          ),
                        ],
                      ),
                    ),
                    PurpleButton(
                      buttonMode: PurpleButtonMode.regular,
                      text: "질문하기",
                      clickAction: () {
                        //TODO 질문 전송
                        controller.questionImageFile.value = XFile("");
                        Get.back();
                      }
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}