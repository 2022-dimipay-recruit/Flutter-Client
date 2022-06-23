import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart';

class UserController extends GetxController {
  final Rx<UserModel> _userModel = UserModel().obs;
  UserModel get user => _userModel.value;

  set user(UserModel value) => _userModel.value = value;

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController nicknameTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  final FocusNode nicknameFocus = new FocusNode();
  final FocusNode descriptionFocus = new FocusNode();
  RxInt changeTextLength = 0.obs;
  RxString nicknameChangeText = "".obs;
  RxString descriptionChangeText = "".obs;

  ImagePicker _imagePicker = Get.find<ImagePicker>();

  @override
  void onInit() {
    nicknameTextController.addListener(() {
      nicknameChangeText.value = nicknameTextController.text;
    });
    descriptionTextController.addListener(() {
      descriptionChangeText.value = descriptionTextController.text;
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
        child: Icon(Icons.person_rounded, color: Colors.white, size: _width * 0.08),
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

  changeProfileImg() async {
    XFile? imageFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    //TODO 백엔드에 사진 업로드 코드
  }

}
