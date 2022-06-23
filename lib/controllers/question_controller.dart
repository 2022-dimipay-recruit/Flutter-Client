import 'package:flutter/cupertino.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/models/user.dart';
import 'package:flutter_recruit_asked/services/shared_preference.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

enum QuestionType {
  personal,
  community
}

enum QuestionStatus {
  answered,
  newQuestion,
  rejected
}


enum QuestionPublicMode {
  anonymous,
  public
}

extension QuestionPublicModeExtension on QuestionPublicMode {
  String get convertStr {
    switch (this) {
      case QuestionPublicMode.anonymous: return "익명";
      case QuestionPublicMode.public: return "공개";
      default: return "";
    }
  }
}


class QuestionController extends GetxController {
  RxString questionMode = "".obs;
  RxString commentMode = "".obs;
  TextEditingController titleTextController = TextEditingController();
  TextEditingController contentTextController = TextEditingController();
  TextEditingController answerTextController = TextEditingController();
  TextEditingController commentTextController = TextEditingController();

  SharedPreference _sharedPreference = SharedPreference();

  ImagePicker _imagePicker = Get.find<ImagePicker>();
  Rx<XFile?> questionImageFile = XFile("").obs;

  getImageFromDevice(ImageSource sourceKind) async => questionImageFile.value = await _imagePicker.pickImage(source: sourceKind);

  getUserList() async {
    return [
      UserModel(
        linkId: "dohui_doch",
        name: "유도희1",
        followers: 15,
      ),
      UserModel(
        linkId: "dohui_doch_2",
        name: "유도희2",
        followers: 2345
      )
    ];
  }

  getLatestSearchList() {
    List<String>? list = _sharedPreference.getLatestSearchList();

    return list != null ? list.obs : <String>[].obs;
  }

  saveLatestSearchList(List<String> data) async => _sharedPreference.saveLatestSearchList(data);

  removeLatestSearchList() async => _sharedPreference.removeLatestSearchList();
}
