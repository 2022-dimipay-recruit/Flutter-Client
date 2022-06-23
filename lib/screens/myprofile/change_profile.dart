import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/screens/widgets/detail_list_button.dart';
import 'package:get/get.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';
import 'change_profile_input_text.dart';

class ChangeProfile extends GetWidget<UserController> {
  ChangeProfile({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    controller.nicknameTextController.text = controller.user.name!;
    controller.descriptionTextController.text = "징징되는 윤징징 핸드폰은 무음모드 깔깔";


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: _width),
                Text("질문하기", style: appBarTitle),
                Positioned(
                  left: _width * 0.075,
                  child: GestureDetector(onTap: () => Get.back(), child: Icon(Icons.arrow_back_ios_sharp, size: 24)),
                ),
                Positioned(
                  right: _width * 0.075,
                  child: GestureDetector(onTap: () => Get.back(), child: Text("저장", style: changeProfileSaveBtn)),
                )
              ],
            ),
            SizedBox(height: _height * 0.0075),
            Divider(color: grayFive, thickness: 1),
            SizedBox(height: _height * 0.04),
            Get.find<UserController>().getProfileWidget(_width, 0.123),
            SizedBox(height: _height * 0.02),
            GestureDetector(
              onTap: () => controller.changeProfileImg(),
              child: Text("프로필 사진 바꾸기", style: changeProfileChangeProfileImg)
            ),
            SizedBox(height: _height * 0.04),
            DetailListButton(
                title: "아이디",
                content: controller.user.id!,
                btnType: DetailListButtonType.gray,
                canClick: false,
            ),
            DetailListButton(
              title: "내 주소",
              content: "asked.kr/${controller.user.id!}",
              btnType: DetailListButtonType.gray,
              canClick: false,
            ),
            Obx(() => DetailListButton(
                title: "닉네임",
                content: controller.nicknameChangeText.value,
                btnType: DetailListButtonType.white,
                canClick: true,
                clickAction: () => Get.to(ChangeProfileInputText(textType: "닉네임", lengthLimit: 15, textEditingController: controller.nicknameTextController, focusNode: controller.nicknameFocus), transition: Transition.rightToLeft)
            )),
            Obx(() => DetailListButton(
                title: "소개",
                content: controller.descriptionChangeText.value,
                btnType: DetailListButtonType.white,
                canClick: true,
                clickAction: () => Get.to(ChangeProfileInputText(textType: "소개", lengthLimit: 80, textEditingController: controller.descriptionTextController, focusNode: controller.descriptionFocus), transition: Transition.rightToLeft)
            )),
            SizedBox(height: _height * 0.015),
            SizedBox(
              width: _width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("개인정보", style: detailListBtnContent.copyWith(color: Colors.black)),
                ],
              ),
            ),
            SizedBox(height: _height * 0.0075),
            DetailListButton(
                title: "이메일 주소",
                content: controller.user.email!,
                btnType: DetailListButtonType.white,
                canClick: false
            )
          ],
        ),
      )
    );
  }
}