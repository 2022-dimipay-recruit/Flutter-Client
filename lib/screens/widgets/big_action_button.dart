import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../themes/text_theme.dart';

enum BigActionButtonType {
  modify,
  remove,
  share,
  bookmark,
  report
}

extension BigActionButtonTypeExtension on BigActionButtonType {
  String get convertIconName {
    switch (this) {
      case BigActionButtonType.modify: return "pencil";
      case BigActionButtonType.remove: return "recycleBin";
      case BigActionButtonType.share: return "share";
      case BigActionButtonType.bookmark: return "bookmark";
      case BigActionButtonType.report: return "warning";
      default: return "";
    }
  }

  String get convertKor {
    switch (this) {
      case BigActionButtonType.modify: return "수정";
      case BigActionButtonType.remove: return "삭제";
      case BigActionButtonType.share: return "공유";
      case BigActionButtonType.bookmark: return "저장";
      case BigActionButtonType.report: return "신고";
      default: return "";
    }
  }
}


class BigActionButton extends StatelessWidget {
  final BigActionButtonType buttonType;
  dynamic clickAction;
  BigActionButton({required this.buttonType, required this.clickAction});

  @override
  Widget build(BuildContext context) {
    final double _displayHeight = MediaQuery.of(context).size.height;
    final double _displayWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: clickAction,
      child: Container(
        width: _displayWidth * 0.92,
        height: _displayHeight * 0.06,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/icons/${buttonType.convertIconName}.svg", color: grayOne, width: 24),
            SizedBox(width: 8),
            Text("답변 ${buttonType.convertKor}하기", style: actionBtn),
          ],
        ),
      ),
    );
  }
}