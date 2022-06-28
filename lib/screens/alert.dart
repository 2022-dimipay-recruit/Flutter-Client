import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/alert_controller.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/screens/widgets/alert_box.dart';
import 'package:flutter_recruit_asked/screens/widgets/community_question_box.dart';
import 'package:flutter_recruit_asked/screens/widgets/custom_tabbar.dart';
import 'package:flutter_recruit_asked/screens/widgets/personal_question_box.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/mainscreen_controller.dart';
import '../../controllers/question_controller.dart';
import '../../models/question.dart';
import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';
import '../models/alert.dart';
import 'myprofile/question_list.dart';

class Alert extends GetWidget<AlertController> {
  Alert({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    MainScreenController _mainScreenController = Get.find<MainScreenController>();
    UserController _userController = Get.find<UserController>();

    controller.getUserAlertList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children:  [
            SizedBox(width: _width, height: _height),
            Text(_userController.user.linkId!, style: appBarTitle),
            Positioned(
              left: _width * 0.075,
              child: GestureDetector(onTap: () => _mainScreenController.showWindow = _mainScreenController.bottomNavigationBarPages[_mainScreenController.selectNavigationBarIndex.value], child: Icon(Icons.arrow_back_ios_sharp, size: 24)),
            ),
            Positioned(
              right: _width * 0.075,
              child: GestureDetector(onTap: () => controller.removeAllAlert(), child: SvgPicture.asset("assets/images/icons/trash.svg")),
            ),
            Positioned(
              bottom: 0,
              child: Obx(() {
                if (!controller.isUserAlertListRefreshing.value) {
                  List<AlertModel> responseData = controller.userAlertList;

                  List tabViewTitleList = ['활동 알림', '팔로워 알림'];
                  Map alertList = {};
                  for (String tabAlertType in tabViewTitleList) {
                    alertList.addAll({tabAlertType: <AlertModel>[]});
                  }

                  responseData.forEach((alert) => (alertList[alert.type! == AlertType.newPost ? "팔로워 알림" : "활동 알림"] as List<AlertModel>).add(alert));


                  return CustomTabBar(
                      width: _width,
                      height: _height * 0.8,
                      indicatorSizeMode: TabBarIndicatorSizeMode.both,
                      tabWindowsList: questionTabView(
                        tabViewTitleList,
                        alertList,
                      )
                  );
                } else { //데이터를 불러오는 중
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(width: _width, height: _height * 0.87),
                      Center(child: CircularProgressIndicator()),
                    ],
                  );
                }
              }),
            )
          ],
        ),
      )
    );
  }

  List<CustomTabWindow> questionTabView(List tabTitleList, Map alertList) {
    List<CustomTabWindow> result = [];

    for (String title in tabTitleList) {
      List tabAlertList = alertList[title];

      result.add(
          CustomTabWindow(
              title: title,
              childWidget: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: _width * 0.875,
                      height: _height * 0.7,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: tabAlertList.length,
                          itemBuilder: (context, index) {
                            return AlertBox(alert: tabAlertList[index]);
                          }
                      ),
                    ),
                  )
                ],
              )
          )
      );
    }

    return result;
  }
}