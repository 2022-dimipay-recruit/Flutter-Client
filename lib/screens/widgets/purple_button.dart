import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';

import '../../themes/text_theme.dart';

class PurpleButton extends StatelessWidget {
  final String text;
  dynamic clickAction;
  PurpleButton({required this.text, required this.clickAction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clickAction,
      child: Container(
        width: 70,
        height: 35,
        decoration: BoxDecoration(
          color: purpleOne,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(child: Text(text, style: purpleBtn)),
      ),
    );
  }
}