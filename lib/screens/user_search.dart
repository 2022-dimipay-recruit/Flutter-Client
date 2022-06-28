import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/mainscreen_controller.dart';
import 'package:flutter_recruit_asked/controllers/question_controller.dart';
import 'package:flutter_recruit_asked/models/user.dart';
import 'package:flutter_recruit_asked/screens/user_page.dart';
import 'package:flutter_recruit_asked/services/shared_preference.dart';
import 'package:get/get.dart';
import 'package:korea_regexp/korea_regexp.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';
import '../controllers/user_controller.dart';

class UserSearch extends SearchDelegate {
  late List<UserModel> _userList;
  late double _width, _height;

  set userList(List<UserModel> list) => _userList = list;

  @override
  String get searchFieldLabel => '아이디 검색';

  @override
  InputDecorationTheme get searchFieldDecorationTheme => InputDecorationTheme(
    hintStyle: searchFieldLabelStyle.copyWith(color: grayTwo),
    labelStyle: searchFieldLabelStyle,
    border: InputBorder.none,
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      GestureDetector(
        onTap: () => query = "",
        child: Icon(Icons.cancel_rounded, size: 19, color: grayThree),
      ),
      SizedBox(width: _width * 0.05),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return GestureDetector(onTap: () => Get.back(), child: Icon(Icons.arrow_back_ios_sharp, color: Colors.black, size: 24));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
        appBarTheme: super.appBarTheme(context).appBarTheme.copyWith(
          elevation: 0.4,
        )
    );
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    QuestionController _questionController = Get.find<QuestionController>();

    RxList<String> latestSearchList = _questionController.getLatestSearchList();

    return FutureBuilder(
        future: _questionController.getUserList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            _userList = List<UserModel>.from(snapshot.data);

            dynamic resultWidget;

            if (query.isNotEmpty) {
              List<UserModel> suggestionList = changeSearchTerm(query);

              resultWidget = ListView.builder(
                itemCount: suggestionList.length,
                itemBuilder: (context, index) {
                  UserModel selectUser = suggestionList[index];

                  return GestureDetector(
                    onTap: () {
                      latestSearchList.value.insert(0, selectUser.linkId!);
                      latestSearchList.value = latestSearchList.value.toSet().toList();
                      _questionController.saveLatestSearchList(latestSearchList.value);

                      showUserWindow(selectUser);
                    },
                    child: ListTile(
                      title: Text(selectUser.name!, style: searchUserBoxTitle),
                      subtitle: Text("팔로워 ${selectUser.followers}", style: searchUserBoxSubTitle),
                      leading: SizedBox(
                        width: _width * 0.1,
                        height: _width * 0.1,
                        child: Get.find<UserController>().getProfileWidget(selectUser, _width, 0.07)
                      ),
                    ),
                  );
                },
              );
            } else {
              resultWidget = Center(
                child: Column(
                  children: [
                    SizedBox(height: _height * 0.04),
                    SizedBox(
                      width: _width * 0.875,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("최근 검색", style: searchLatestSearchTitle),
                          GestureDetector(
                            onTap: () {
                              _questionController.removeLatestSearchList();
                              latestSearchList.value = [];
                            },
                            child: Text("전체 삭제", style: searchLatestSearchAllRemove)
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: _height * 0.02),
                    SizedBox(
                      width: _width * 0.875,
                      height: _height * 0.7,
                      child: Obx(() => ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: latestSearchList.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: _height * 0.03,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        bool isFindUserInfo = false;

                                        _userList.forEach((element) {
                                          if (element.linkId! == latestSearchList[index]) {
                                            showUserWindow(element);
                                            isFindUserInfo = true;
                                          }
                                        });

                                        if (!isFindUserInfo) { Get.find<UserController>().showToast("유저 정보를 불러오는데 실패하였습니다."); }
                                      },
                                      child: Text(latestSearchList[index], style: searchLatestSearchUserId),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      latestSearchList.remove(latestSearchList[index]);
                                      _questionController.saveLatestSearchList(latestSearchList);
                                    },
                                    child: Icon(Icons.close_rounded, color: Colors.black, size: 12)
                                  )
                                ],
                              ),
                            );
                          }
                      ))
                    ),
                  ],
                ),
              );
            }


            return Scaffold(
              backgroundColor: Colors.white,
              body: resultWidget,
            );
          } else if (snapshot.hasError) { //데이터를 정상적으로 불러오지 못했을 때
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: _width, height: _height * 0.4),
                Center(child: Text("데이터를 정상적으로 불러오지 못했습니다. \n다시 시도해 주세요.", textAlign: TextAlign.center)),
              ],
            );
          } else { //데이터를 불러오는 중
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: _width, height: _height * 0.4),
                Center(child: CircularProgressIndicator()),
              ],
            );
          }
        }
    );
  }

  changeSearchTerm(String text) {
    RegExp regExp = getRegExp(
        text,
        RegExpOptions(
          initialSearch: true,
          startsWith: false,
          endsWith: false,
          fuzzy: false,
          ignoreSpace: false,
          ignoreCase: false,
        )
    );

    List<UserModel> result = [];
    result.addAll(_userList.where((element) => regExp.hasMatch(element.name as String)).toList());
    result.addAll(_userList.where((element) => regExp.hasMatch(element.linkId.toString())).toList());


    return result;
  }

  showUserWindow(UserModel user) {
    Get.find<MainScreenController>().userInUserPage.value = user;
    Get.find<MainScreenController>().selectNavigationBarIndex.value = 2;
    Get.find<MainScreenController>().showWindow = UserPage();
    Get.back();
  }
}