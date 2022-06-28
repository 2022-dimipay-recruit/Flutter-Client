import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:get/get.dart';

import '../../themes/text_theme.dart';

class PurpleSwitch extends StatelessWidget {
  final List optionList;
  RxString nowValue;
  PurpleSwitch({required this.optionList, required this.nowValue});

  @override
  Widget build(BuildContext context) {
    if (nowValue.value.isEmpty) { nowValue.value = optionList[0]; }

    Duration animateDuration = const Duration(milliseconds: 200);

    return Obx(() => GestureDetector(
      onTap: () => nowValue.value = (nowValue.value == optionList[0] ? optionList[1] : optionList[0]),
      child: Container(
        width: 72,
        height: 29,
        decoration: BoxDecoration(
          color: purpleOne,
          borderRadius: BorderRadius.circular(14.5)
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              left: nowValue.value == optionList[0] ? 4 : 35,
              duration: animateDuration,
              child: Container(
                width: 33,
                height: 23,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(11.5)
                ),
              ),
            ),
            SizedBox(
              width: 55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: animateDuration,
                    style: purpleSwitch.copyWith(color: nowValue.value == optionList[0] ? purpleOne : Colors.white),
                    child: Text(optionList[0])
                  ),
                  AnimatedDefaultTextStyle(
                      duration: animateDuration,
                      style: purpleSwitch.copyWith(color: nowValue.value == optionList[1] ? purpleOne : Colors.white),
                      child: Text(optionList[1])
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ));
  }
}