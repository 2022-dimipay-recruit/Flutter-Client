import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../screens/home.dart';

class MainScreenController extends GetxController {
  RxInt selectNavigationBarIndex = 0.obs;
  RxList<Widget> nowShowWindow = <Widget>[Home()].obs;

  set changeShowWindow(Widget window) => nowShowWindow.value = [window];
}
