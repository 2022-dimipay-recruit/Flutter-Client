import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';

import '../../themes/text_theme.dart';

enum TabBarIndicatorSizeMode {
  text,
  highlight,
  both
}

class CustomTabBar extends StatelessWidget {
  double width;
  double height;
  TabBarIndicatorSizeMode indicatorSizeMode;
  List<CustomTabWindow> tabWindowsList;
  CustomTabBar({required this.width, required this.height, required this.indicatorSizeMode, required this.tabWindowsList});

  @override
  Widget build(BuildContext context) {
    List<Widget> tabList = [];
    tabWindowsList.forEach((element) => tabList.add(Tab(text: element.title)));
    List<Widget> tabBarViewList = []; tabWindowsList.forEach((element) => tabBarViewList.add(element.childWidget));

    return SizedBox(
      width: width,
      height: height,
      child: DefaultTabController(
        length: tabWindowsList.length,
        initialIndex: 0,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
                height: 50.0,
                child: TabBar(
                  isScrollable: indicatorSizeMode == TabBarIndicatorSizeMode.highlight ? true : false,
                  unselectedLabelColor: grayTwo,
                  labelColor: Colors.black,
                  labelStyle: tabBarTitle,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: purpleOne, width: 2),
                  ),
                  indicatorSize: indicatorSizeMode == TabBarIndicatorSizeMode.text ? TabBarIndicatorSize.label : TabBarIndicatorSize.tab,
                  tabs: tabList,
                )
            ),
          ),
          body: TabBarView(children: tabBarViewList),
        ),
      ),
    );
  }
}

class CustomTabWindow {
  String? _title;
  dynamic _childWidget;

  String? get title => _title;
  dynamic get childWidget => _childWidget;

  CustomTabWindow({
    required String title,
    required dynamic childWidget,
  }){
    _title = title;
    _childWidget = childWidget;
  }
}