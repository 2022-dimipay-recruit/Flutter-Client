import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../screens/community.dart';
import '../screens/home.dart';
import '../screens/myprofile/my_profile.dart';
import '../screens/search.dart';

class MainScreenController extends GetxController {
  RxInt selectNavigationBarIndex = 0.obs;
  RxList<Widget> nowShowWindow = <Widget>[Home()].obs;

  set showWindow(Widget window) => nowShowWindow.value = [window];

  List bottomNavigationBarPages = [
    Home(),
    Community(),
    Search(),
    MyProfile()
  ];
}
