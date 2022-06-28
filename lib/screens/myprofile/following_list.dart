import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/mainscreen_controller.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/models/user.dart';
import 'package:flutter_recruit_asked/screens/widgets/detail_list_button.dart';
import 'package:flutter_recruit_asked/screens/widgets/following_person_box.dart';
import 'package:get/get.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';
import 'change_profile_input_text.dart';

class FollowingList extends GetWidget<UserController> {
  FollowingList({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    MainScreenController _mainScreenController = Get.find<MainScreenController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(width: _width, height: _height),
            Text(controller.user.linkId!, style: appBarTitle),
            Positioned(
              left: _width * 0.075,
              child: GestureDetector(onTap: () => _mainScreenController.showWindow = _mainScreenController.bottomNavigationBarPages[3], child: Icon(Icons.arrow_back_ios_sharp, size: 24)),
            ),
            Positioned(
              top: _height * 0.07,
              left: _width * 0.075,
              child: Text("팔로잉 목록", style: followingListTitle)
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: _width * 0.875,
                height: _height * 0.73,
                child: FutureBuilder(
                  future: controller.getFollowingUserList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<UserModel> responseData = snapshot.data as List<UserModel>;

                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: responseData.length,
                          itemBuilder: (context, index) {
                            return FollowingPersonBox(user: responseData[index]);
                          }
                      );
                    } else if (snapshot.hasError) { //데이터를 정상적으로 불러오지 못했을 때
                      //print(snapshot.data);
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(width: _width, height: _height * 0.87),
                          Center(child: Text("데이터를 정상적으로 불러오지 못했습니다. \n다시 시도해 주세요.", textAlign: TextAlign.center)),
                        ],
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
                  },
                )
              ),
            )
          ],
        ),
      )
    );
  }
}