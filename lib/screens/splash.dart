import 'package:flutter/material.dart';

import '../themes/color_theme.dart';
import '../themes/text_theme.dart';

class Splash extends StatelessWidget {
  Splash({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: purpleOne,
      body: Center(
        child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                  "assets/images/splash/background.png",
                  width: _width * 1.3,
                  height: _height * 1.3
              ),
              Text("Disked", style: splashLogo),
            ]
        )
      )
    );
  }
}