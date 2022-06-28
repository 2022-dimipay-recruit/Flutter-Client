import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/alert_controller.dart';
import 'package:flutter_recruit_asked/controllers/mainscreen_controller.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../themes/text_theme.dart';
import '../alert.dart';

enum AlertButtonMode {
  newAlert,
  allRead,
}

class AlertButton extends GetWidget<AlertController> {
  AlertButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _displayWidth = MediaQuery.of(context).size.width;

    MainScreenController _mainScreenController = Get.find<MainScreenController>();

    return GestureDetector(
      onTap: () => _mainScreenController.showWindow = Alert(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: 23),
          SvgPicture.asset(
            "assets/images/icons/alert.svg",
          ),
          Obx(() => (controller.hasNewAlert.value ?
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
          ))
        ],
      )
    );
  }
}