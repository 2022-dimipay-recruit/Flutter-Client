import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class Login extends GetWidget<AuthController> {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("디미페이 로그인"),
            SizedBox(height: _height * 0.1),
            GestureDetector(
              onTap: () => controller.signInWithGoogle(),
              child: Text("구글로 로그인(텍스트 클릭 시 진행)"),
            )
          ],
        ),
      ),
    );
  }
}
