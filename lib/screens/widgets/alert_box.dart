import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/question_controller.dart';
import 'package:flutter_recruit_asked/models/user.dart';
import 'package:flutter_recruit_asked/screens/widgets/purple_button.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../models/alert.dart';
import '../../themes/text_theme.dart';

class AlertBox extends StatelessWidget {
  final AlertModel alert;
  AlertBox({required this.alert});

  @override
  Widget build(BuildContext context) {
    final double _displayHeight = MediaQuery.of(context).size.height;
    final double _displayWidth = MediaQuery.of(context).size.width;

    QuestionController _questionController = Get.find<QuestionController>();

    return SizedBox(
      width: _displayWidth * 0.9,
      height: _displayHeight * 0.09,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${_questionController.simpleDateFormat.format(alert.date!)}에 온 알림", style: questionAnswerDate),
                  SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alert.content!, style: personBoxSubTitle.copyWith(fontWeight: !alert.isRead! ? FontWeight.w600 : FontWeight.w400)),
                      SizedBox(width: 4),
                      (!alert.isRead! ?
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: purpleOne,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ) : SizedBox()
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      )
    );
  }
}