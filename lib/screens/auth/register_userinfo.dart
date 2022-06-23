import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/screens/widgets/purple_button.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:flutter_recruit_asked/themes/text_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

class RegisterUserInfo extends GetWidget<AuthController> {
  RegisterUserInfo({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(height: _height, width: _width),
          SizedBox(
            width: _width * 0.641,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("아이디와 닉네임을 설정해주세요.", style: userInfoTitle),
                SizedBox(height: _height * 0.05),
                infoTextField(controller.idTextController, "아이디"),
                SizedBox(height: _height * 0.02),
                infoTextField(controller.nicknameTextController, "닉네임"),
              ],
            ),
          ),
          Positioned(
            bottom: _height * 0.125,
            child: PurpleButton(
              buttonMode: PurpleButtonMode.large,
              text: "확인",
              clickAction: () {
                controller.loginUserInfo["name"] = controller.nicknameTextController.text;
                controller.loginUserInfo["linkId"] = controller.idTextController.text;

                controller.writeAccountInfo();
                controller.isLogin.value = true;
                Get.back();
              }
            ),
          )
        ],
      )
    );
  }

  infoTextField(TextEditingController controller, String hintText) {
    return SizedBox(
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller,
        style: userInfoTextField,
        cursorColor: purpleOne,
        decoration: InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide(width: 0.5)),
          hintText: hintText,
          hintStyle: userInfoTextField.copyWith(color: grayOne),
        ),
      ),
    );
  }
}