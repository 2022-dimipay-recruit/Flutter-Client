import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/mainscreen_controller.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../themes/text_theme.dart';

class MainScreen extends GetWidget<MainScreenController> {
  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map pageIcon = {
      '홈': 'home',
      '커뮤니티': 'community',
      '검색': 'search',
      '내 정보': 'user'
    };

    List<BottomNavigationBarItem> bottomNavigatorItem = [
      BottomNavigationBarItem(
        label: "홈",
        icon: SvgPicture.asset('assets/images/icons/home_select.svg'),
      ),
      BottomNavigationBarItem(
        label: "커뮤니티",
        icon: SvgPicture.asset('assets/images/icons/community_unselect.svg'),
      ),
      BottomNavigationBarItem(
        label: "검색",
        icon: SvgPicture.asset('assets/images/icons/search_unselect.svg'),
      ),
      BottomNavigationBarItem(
        label: "내 정보",
        icon: SvgPicture.asset('assets/images/icons/user_unselect.svg'),
      ),
    ];

    for (int i=0; i < controller.bottomNavigationBarPages.length; i++) {
      String? label = bottomNavigatorItem[i].label;
      bottomNavigatorItem[i] = BottomNavigationBarItem(
        label: label,
        icon: Obx(() => SvgPicture.asset('assets/images/icons/${pageIcon[label]}_${controller.selectNavigationBarIndex.value == i ? "select" : "unselect"}.svg')),
      );
    }

    return Obx(() => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: purpleOne,
          unselectedItemColor: grayFour,
          selectedLabelStyle: homeBottomNavigationBarLabel,
          unselectedLabelStyle: homeBottomNavigationBarLabel.copyWith(fontWeight: FontWeight.w400),
          selectedFontSize: 12,
          currentIndex: controller.selectNavigationBarIndex.value,
          onTap: (int index) {
            controller.selectNavigationBarIndex.value = index;
            controller.nowShowWindow.value = [controller.bottomNavigationBarPages[controller.selectNavigationBarIndex.value]];
          },
          items: bottomNavigatorItem,
        ),
        body: controller.nowShowWindow[0]
    ));
  }

}
