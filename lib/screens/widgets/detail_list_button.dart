import 'package:flutter/material.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';


enum DetailListButtonType {
  gray,
  white
}

extension DetailListButtonTypeExtension on DetailListButtonType {
  Color get getBackgroundColor {
    switch (this) {
      case DetailListButtonType.gray: return graySix;
      case DetailListButtonType.white: return Colors.white;
      default: return Colors.transparent;
    }
  }

  Color get getTextColor {
    switch (this) {
      case DetailListButtonType.gray: return Colors.black;
      case DetailListButtonType.white: return purpleOne;
      default: return Colors.transparent;
    }
  }
}


class DetailListButton extends StatelessWidget {
  final String title;
  final String content;
  final DetailListButtonType btnType;
  final bool canClick;
  dynamic clickAction;
  DetailListButton({required this.title, required this.content, required this.btnType, required this.canClick, this.clickAction});

  @override
  Widget build(BuildContext context) {
    final double _displayHeight = MediaQuery.of(context).size.height;
    final double _displayWidth = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: clickAction,
        child: Container(
          height: _displayHeight * 0.08,
          width: _displayWidth,
          color: btnType.getBackgroundColor,
          child: Center(
              child: SizedBox(
                width: _displayWidth * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: detailListBtnTitle.copyWith(color: btnType.getTextColor)),
                        SizedBox(height: 4),
                        Text(content, style: detailListBtnContent.copyWith(fontWeight: btnType == DetailListButtonType.gray ? FontWeight.w500 : FontWeight.w400)),
                      ],
                    ),
                    (
                      canClick ?
                      Icon(Icons.chevron_right_rounded, color: purpleOne, size: 16) :
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