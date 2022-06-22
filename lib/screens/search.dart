import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../themes/color_theme.dart';

class Search extends StatelessWidget {
  Search({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Search Page"),
          ],
        )
      ),
    );
  }
}