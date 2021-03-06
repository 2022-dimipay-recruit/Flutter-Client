import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:flutter_recruit_asked/themes/text_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

class Login extends GetWidget<AuthController> {
  Login({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/logo.svg",
            ),
            SizedBox(height: _height * 0.02),
            const Text("Disked", style: loginTitle),
            SizedBox(height: _height * 0.01),
            const Text("디미고에 대해 궁금한 모든 것", style: loginSubTitle),
            SizedBox(height: _height * 0.225),
            GestureDetector(
                onTap: () => controller.signInWithKakao(),
                child: loginBtnWidget(false)
            ),
            SizedBox(height: _height * 0.02),
            GestureDetector(
                onTap: () => controller.signInWithGoogle(),
                child: loginBtnWidget(true)
            ),
          ],
        ),
      ),
    );
  }

  loginBtnWidget(bool isGoogleLogin) {
    return Container(
      width: _width * 0.92,
      height: _height * 0.065,
      decoration: BoxDecoration(
          color: isGoogleLogin ? Colors.white : yellowOne,
          borderRadius: BorderRadius.circular(5),
          border: isGoogleLogin ? Border.all(color: Colors.black) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/${isGoogleLogin ? "google" : "kakao"}Icon.svg",
            width: _width * 0.055,
          ),
          SizedBox(width: _width * 0.03),
          Text("${isGoogleLogin ? "구글" : "카카오"}로 로그인", style: loginBtn)
        ],
      ),
    );
  }
}
