import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/question_controller.dart';
import 'package:get/get.dart';

import '../../themes/text_theme.dart';

enum SortButtonType {
  latest,
  oldest
}

extension SortButtonTypeExtension on SortButtonType {
  String get convertKor {
    switch (this) {
      case SortButtonType.latest: return "최신순";
      case SortButtonType.oldest: return "과거순";
      default: return "";
    }
  }
}


class SortButton extends StatelessWidget {
  final Rx<SortButtonType> btnType;
  final QuestionType questionType;
  SortButton({required this.btnType, required this.questionType});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: () {
        QuestionController _questionController = Get.find<QuestionController>();


        btnType.value = (btnType.value == SortButtonType.latest ? SortButtonType.oldest : SortButtonType.latest);

        if (questionType == QuestionType.personal) {
          _questionController.isPersonalQuestionListRefreshing.value = true;
          Future.delayed(Duration(milliseconds: 15), () => _questionController.isPersonalQuestionListRefreshing.value = false);
        } else {
          _questionController.isCommunityQuestionListRefreshing.value = true;
          Future.delayed(Duration(milliseconds: 15), () => _questionController.isCommunityQuestionListRefreshing.value = false);
        }
      },
      child: Row(
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
          Text(btnType.value.convertKor, style: questionListSort),
        ],
      ),
    ));
  }
}