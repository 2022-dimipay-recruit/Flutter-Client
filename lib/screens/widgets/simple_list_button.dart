import 'package:flutter/material.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';


enum SimpleListButtonType {
  black,
  red,
}

extension SimpleListButtonTypeExtension on SimpleListButtonType {
  Color get getColor {
    switch (this) {
      case SimpleListButtonType.black: return Colors.black;
      case SimpleListButtonType.red: return redOne;
      default: return Colors.transparent;
    }
  }
}


class SimpleListButton extends StatelessWidget {
  final String text;
  final SimpleListButtonType btnType;
  dynamic clickAction;
  SimpleListButton({required this.text, required this.btnType, required this.clickAction});

  @override
  Widget build(BuildContext context) {
    final double _displayHeight = MediaQuery.of(context).size.height;
    final double _displayWidth = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.white,
      child: InkWell(
          onTap: clickAction,
          child: SizedBox(
            height: _displayHeight * 0.055,
            width: _displayWidth,
            child: Center(
                child: SizedBox(
                  width: _displayWidth * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(text, style: simpleListBtn.copyWith(color: btnType.getColor)),
                      (
                          btnType == SimpleListButtonType.black ?
                          Icon(Icons.chevron_right_rounded, color: Colors.black, size: 15) :
                          SizedBox()
                      )
                    ],
                  ),
                )
            ),
          )
      ),
    );
  }
}