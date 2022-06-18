import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/screens/widgets/custom_tabbar.dart';
import 'package:flutter_recruit_asked/screens/widgets/purple_button.dart';
import 'package:flutter_recruit_asked/screens/widgets/small_action_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../themes/color_theme.dart';
import '../themes/text_theme.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    UserController _userController = Get.find<UserController>();


    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(width: _width),
                      Text("dohui_doch", style: appBarUserId),
                      Positioned(
                        right: _width * 0.075,
                        child: SvgPicture.asset(
                          "assets/images/icons/alert.svg",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _height * 0.0225),
                  SizedBox(
                    width: _width * 0.85,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: _width * 0.105,
                              child: ClipRRect(
                                child: _userController.getProfileImg(_width),
                                borderRadius: BorderRadius.circular(180.0),
                              ),
                            ),
                            SizedBox(width: _width * 0.05),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("유도히", style: profileNickname),
                                    SizedBox(width: _width * 0.0125),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: purpleOne
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/images/icons/share.svg",
                                          color: Colors.white,
                                          width: 16,
                                          height: 16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text("팔로워 213", style: profileFollwer),
                                SizedBox(height: 2),
                                Text("반가워요 여러분", style: profileIntroduce),
                              ],
                            )
                          ],
                        ),
                        PurpleButton(text: "질문하기"),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                child: CustomTabBar(
                    width: _width * 0.95,
                    height: _height * 0.675,
                    indicatorSizeMode: TabBarIndicatorSizeMode.text,
                    tabWindowsList: questionTabView(["답변완료 160", "새질문 16", "거절질문 6"])
                ),
              )
            ],
          )
        )
      ),
    );
  }

  List<CustomTabWindow> questionTabView(List tabTitleList) {
    List<CustomTabWindow> result = [];

    for (String title in tabTitleList) {
      result.add(
        CustomTabWindow(
          title: title,
          childWidget: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                right: _width * 0.05,
                child: Row(
                  children: [
                    SizedBox(
                      height: 37,
                      width: 27,
                      child: Stack(
                        children: [
                          Positioned(top: 0, child: Icon(Icons.arrow_drop_up_rounded, size: 30)),
                          Positioned(bottom: 0, child: Icon(Icons.arrow_drop_down_rounded, size: 30)),
                        ],
                      ),
                    ),
                    Text("최신순", style: questionListSort),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: _width * 0.875,
                  height: _height * 0.57,
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return questionBox(context);
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

  questionBox(BuildContext context) {
    return Container(
      width: _width * 0.85,
      margin: EdgeInsets.only(bottom: _height * 0.04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: purpleOne
                ),
                child: Center(
                  child: Text("Q", style: questionCircleIcon),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("익명", style: questionType),
                  SizedBox(height: 4),
                  Text("하이 방가워", style: questionContent),
                ],
              )
            ],
          ),
          SizedBox(height: _height * 0.02),
          SizedBox(
            width: _width * 0.84,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: _width * 0.061,
                      child: ClipRRect(
                        child: Get.find<UserController>().getProfileImg(_width),
                        borderRadius: BorderRadius.circular(180.0),
                      ),
                    ),
                    SizedBox(width: _width * 0.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("윤지", style: questionAnswerPerson),
                            SizedBox(width: 2),
                            Text("2주 전", style: questionAnswerDate),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text("메롱이다 메롱", style: questionAnswerContent)
                      ],
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () => print("clicked"),
                  child: Icon(Icons.more_vert_rounded, color: grayOne)
                )
              ],
            ),
          ),
          SizedBox(height: _height * 0.02),
          Center(
            child: SizedBox(
              width: _width * 0.75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmallActionButton(buttonType: SmallActionButtonType.like, clickAction: () => print("좋아요")),
                  SmallActionButton(buttonType: SmallActionButtonType.modify, clickAction: () => print("수정")),
                  SmallActionButton(buttonType: SmallActionButtonType.remove, clickAction: () => print("지우기")),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}