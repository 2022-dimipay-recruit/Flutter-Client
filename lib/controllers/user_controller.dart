import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/question_controller.dart';
import 'package:flutter_recruit_asked/models/question.dart';
import 'package:flutter_recruit_asked/screens/widgets/follow_button.dart';
import 'package:flutter_recruit_asked/services/api_provider.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../models/user.dart';
import 'mainscreen_controller.dart';

class  UserController extends GetxController {
  final Rx<UserModel> _userModel = UserModel().obs;
  UserModel get user => _userModel.value;
  Rx<UserModel> get userModel => _userModel;

  set user(UserModel value) => _userModel.value = value;

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController nicknameTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  final FocusNode nicknameFocus = new FocusNode();
  final FocusNode descriptionFocus = new FocusNode();
  RxInt changeTextLength = 0.obs;
  RxString nicknameChangeText = "".obs;
  RxString descriptionChangeText = "".obs;
  RxString profileImageUrl = "".obs;
  Rx<FollowButtonType> followBtnType = FollowButtonType.follow.obs;

  ImagePicker _imagePicker = Get.find<ImagePicker>();
  late ApiProvider _apiProvider;
  late QuestionController _questionController;

  @override
  void onInit() {
    nicknameTextController.addListener(() {
      nicknameChangeText.value = nicknameTextController.text;
    });
    descriptionTextController.addListener(() {
      descriptionChangeText.value = descriptionTextController.text;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      _apiProvider = Get.find<ApiProvider>();
      _questionController = Get.find<QuestionController>();
    });

    super.onInit();
  }

  void clear() {
    _userModel.value = UserModel();
  }

  dynamic getProfileWidget(UserModel user, double _width, double radiusRatio) {
    dynamic imageWidget;
    if (user.profileImg == null || user.profileImg == "") {
      imageWidget = Container(
        height: _width * 0.17,
        width: _width * 0.17,
        decoration: BoxDecoration(
          color: purpleOne,
          borderRadius: BorderRadius.circular(150)
        ),
        child: Icon(Icons.person_rounded, color: Colors.white, size: _width * (radiusRatio * 1.4)),
      );
    } else {
      imageWidget = ExtendedImage.network(user.profileImg!, cache: true);
    }

    return CircularProfileAvatar(
      '',
      child: imageWidget,
      radius: _width * radiusRatio,
      backgroundColor: Colors.transparent,
      cacheImage: true,
    );
  }

  shareProfile(UserModel shareUser) async => Share.share('매일매일 새롭고 재미있는 질문이 올라오는 곳, Disked 앱에 참여해보세요!\n\n${user.name!}님이 ${shareUser.name!}(${shareUser.linkId!}) 유저를 공유하였습니다.');

  followOtherUser(String uid, QuestionType questionType, Rx<FollowButtonType> btnType) async {
    Map result = await _apiProvider.followOtherUser(uid);

    questionType == QuestionType.personal ? _questionController.getUserPersonalQuestionList(Get.find<MainScreenController>().userInUserPage.value.id!) : _questionController.getCommunityQuestionList();
    showToast("유저 팔로우에 ${result['success'] ? "성공" : "실패"}하였습니다.");
    if (result['success']) { btnType.value = (btnType.value == FollowButtonType.follow ? FollowButtonType.unfollow : FollowButtonType.follow); }
  }

  unfollowOtherUser(String uid, QuestionType questionType, Rx<FollowButtonType> btnType) async {
    Map result = await _apiProvider.unfollowOtherUser(uid);

    questionType == QuestionType.personal ? _questionController.getUserPersonalQuestionList(Get.find<MainScreenController>().userInUserPage.value.id!) : _questionController.getCommunityQuestionList();
    showToast("유저 언팔로우에 ${result['success'] ? "성공" : "실패"}하였습니다.");
    if (result['success']) { btnType.value = (btnType.value == FollowButtonType.follow ? FollowButtonType.unfollow : FollowButtonType.follow); }
  }

  getFollowingUserList() async => (await _apiProvider.getFollowingUserList(user.id!))['content'];

  changeProfileImg() async {
    Map result = await _apiProvider.uploadImageFile(await _imagePicker.pickImage(source: ImageSource.gallery));
    profileImageUrl.value = "${_apiProvider.apiUrl}/images/${result['content']['filename']}";
  }

  updateProfileInfo() async {
    Map modifyInfo = _userModel.value.toJson();
    modifyInfo['nickname'] = nicknameTextController.text;
    modifyInfo['description'] = descriptionTextController.text;
    if (profileImageUrl.value != "") { modifyInfo['profileImage'] = profileImageUrl.value; }
    UserModel modifyUser = UserModel.fromJson(modifyInfo);

    Map result = await _apiProvider.updateUserProfile(modifyUser);
    user = modifyUser;

    if (result['success']) {
      showToast("성공적으로 수정되었습니다.");
      profileImageUrl.value = "";
    } else {
      showToast("오류가 발생하였습니다.");
    }

    Get.back();

  }

  showToast(String message) => Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xE6FFFFFF),
      textColor: Colors.black,
      fontSize: 13.0
  );
}
