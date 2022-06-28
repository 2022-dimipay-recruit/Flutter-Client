import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../themes/text_theme.dart';

enum SmallActionButtonType {
  like,
  unlike,
  modify,
  remove,
  comment,
  answer,
  reject
}

extension SmallActionButtonTypeExtension on SmallActionButtonType {
  String get convertIconName {
    switch (this) {
      case SmallActionButtonType.like: return "heart_unfill";
      case SmallActionButtonType.unlike: return "heart_fill";
      case SmallActionButtonType.modify: return "pencil";
      case SmallActionButtonType.remove: return "recycleBin";
      case SmallActionButtonType.comment: return "write_text";
      case SmallActionButtonType.answer: return "pencil";
      case SmallActionButtonType.reject: return "cancel";
      default: return "";
    }
  }

  String get convertKor {
    switch (this) {
      case SmallActionButtonType.like: return "좋아요";
      case SmallActionButtonType.unlike: return "좋아요";
      case SmallActionButtonType.modify: return "수정";
      case SmallActionButtonType.remove: return "삭제";
      case SmallActionButtonType.comment: return "댓글";
      case SmallActionButtonType.answer: return "답변";
      case SmallActionButtonType.reject: return "거절";
      default: return "";
    }
  }
}


class SmallActionButton extends StatelessWidget {
  final SmallActionButtonType buttonType;
  dynamic clickAction;
  SmallActionButton({required this.buttonType, required this.clickAction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clickAction,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/images/icons/${buttonType.convertIconName}.svg", color: grayOne, width: 15),
          SizedBox(width: 8),
          Text(buttonType.convertKor, style: actionBtn),
        ],
      ),
    );
  }
}