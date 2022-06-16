import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/screens/community.dart';
import 'package:flutter_recruit_asked/screens/my_profile.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import '../screens/home.dart';
import '../screens/search.dart';
import '../themes/text_theme.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen> {
  int _selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    Map pageIcon = {
      '홈': 'home',
      '커뮤니티': 'community',
      '검색': 'search',
      '내 정보': 'user'
    };

    List pages = [
      Home(),
      Community(),
      Search(),
      MyProfile()
    ];

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

    for (int i=0; i<pages.length; i++) {
      String? label = bottomNavigatorItem[i].label;
      bottomNavigatorItem[i] = BottomNavigationBarItem(
        label: label,
        icon: SvgPicture.asset('assets/images/icons/${pageIcon[label]}_${_selectIndex == i ? "select" : "unselect"}.svg'),
      );
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: purpleOne,
        unselectedItemColor: grayFour,
        selectedLabelStyle: homeBottomNavigationBarLabel,
        unselectedLabelStyle: homeBottomNavigationBarLabel.copyWith(fontWeight: FontWeight.w400),
        selectedFontSize: 12,
        currentIndex: _selectIndex,
        onTap: (int index) {
          setState(() {
            _selectIndex = index;
          });
        },
        items: bottomNavigatorItem,
      ),
      body: pages[_selectIndex]
    );
  }
}