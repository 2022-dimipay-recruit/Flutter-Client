import 'package:flutter/material.dart';

import '../../themes/text_theme.dart';

enum SortButtonType {
  latest
}

extension SortButtonTypeExtension on SortButtonType {
  String get convertKor {
    switch (this) {
      case SortButtonType.latest: return "최신순";
      default: return "";
    }
  }
}


class SortButton extends StatelessWidget {
  final SortButtonType btnType;
  SortButton({required this.btnType});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 37,
          width: 27,
          child: Stack(
            children: [
              Positioned(top: 0, child: Icon(Icons.arrow_drop_up_rounded, size: 30)),
              Positioned(bottom: 0, child: Icon(Icons.arrow_drop_down_rounded, size: 30)),
            ],
          ),
        ),
        Text(btnType.convertKor, style: questionListSort),
      ],
    );
  }
}