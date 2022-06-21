import 'package:flutter/material.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';


enum ListButtonType {
  black,
  red,
}

extension SmallActionButtonTypeExtension on ListButtonType {
  Color get getColor {
    switch (this) {
      case ListButtonType.black: return Colors.black;
      case ListButtonType.red: return redOne;
      default: return Colors.transparent;
    }
  }
}


class ListButton extends StatelessWidget {
  final String text;
  final ListButtonType btnType;
  dynamic clickAction;
  ListButton({required this.text, required this.btnType, required this.clickAction});

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
                    Text(text, style: listBtn.copyWith(color: btnType.getColor)),
                    (
                      btnType == ListButtonType.black ?
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