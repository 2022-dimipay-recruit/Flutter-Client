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

  getProfileImg(double _width) {
    if (user.profileImg == null || user.profileImg == "") {
      return Container(
        height: _width * 0.17,
        width: _width * 0.17,
        decoration: BoxDecoration(
          color: purpleOne,
          borderRadius: BorderRadius.circular(150)
        ),
        child: Icon(Icons.person_rounded, size: _width * 0.12),
      );
    } else {
      return ExtendedImage.network(user.profileImg!, cache: true);
    }
  }

  changeProfileImg() async {
    XFile? imageFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    //TODO 백엔드에 사진 업로드 코드
  }

}
