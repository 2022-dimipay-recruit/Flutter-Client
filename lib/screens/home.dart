import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../themes/color_theme.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;


    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Home Page"),
            SizedBox(height: _height * 0.1),
            GestureDetector(
              onTap: () => Get.find<AuthController>().logOut(),
              child: Text("클릭시 로그아웃"),
            )
          ],
        )
      ),
    );
  }
}