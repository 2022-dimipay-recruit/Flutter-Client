import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';

import '../../themes/text_theme.dart';

enum PurpleButtonMode {
  regular,
  large,
}

class PurpleButton extends StatelessWidget {
  final PurpleButtonMode buttonMode;
  final String text;
  dynamic clickAction;
  PurpleButton({required this.buttonMode, required this.text, required this.clickAction});

  @override
  Widget build(BuildContext context) {
    final double _displayWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: clickAction,
      child: Container(
        width: buttonMode == PurpleButtonMode.regular ? 70 : _displayWidth * 0.923,
        height: buttonMode == PurpleButtonMode.regular ? 35 : 50,
        decoration: BoxDecoration(
          color: purpleOne,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(child: Text(text, style: buttonMode == PurpleButtonMode.regular ? purpleBtn : purpleBtn.copyWith(fontSize: 16))),
      ),
    );
  }
}