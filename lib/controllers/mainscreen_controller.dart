import 'package:flutter/cupertino.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:get/get.dart';

import '../screens/community.dart';
import '../screens/user_page.dart';
import '../screens/myprofile/my_profile.dart';

class MainScreenController extends GetxController {
  RxInt selectNavigationBarIndex = 0.obs;
  RxList<Widget> nowShowWindow = <Widget>[UserPage(user: Get.find<UserController>().user, isMyPage: true)].obs;

  set showWindow(Widget window) => nowShowWindow.value = [window];

  List bottomNavigationBarPages = [
    UserPage(user: Get.find<UserController>().user, isMyPage: true),
    Community(),
    null,
    MyProfile()
  ];
}
