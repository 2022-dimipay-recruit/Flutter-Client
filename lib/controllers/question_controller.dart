import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/models/comment.dart';
import 'package:flutter_recruit_asked/models/question.dart';
import 'package:flutter_recruit_asked/models/user.dart';
import 'package:flutter_recruit_asked/screens/widgets/sort_button.dart';
import 'package:flutter_recruit_asked/services/api_provider.dart';
import 'package:flutter_recruit_asked/services/shared_preference.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import 'mainscreen_controller.dart';

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

extension QuestionStatusExtension on QuestionStatus {
  String get convertStr {
    switch (this) {
      case QuestionStatus.answered: return "답변완료";
      case QuestionStatus.newQuestion: return "새질문";
      case QuestionStatus.rejected: return "거절질문";
      default: return "";
    }
  }
}

extension QuestionTypeExtension on QuestionType {
  String get convertStr {
    switch (this) {
      case QuestionType.personal: return "개인 활동";
      case QuestionType.community: return "커뮤니티";
      default: return "";
    }
  }
}

extension QuestionEnumExtension on String {
  QuestionPublicMode get convertQuestionPublicMode {
    switch (this) {
      case "익명": return QuestionPublicMode.anonymous;
      case "공개": return QuestionPublicMode.public;
      default: return QuestionPublicMode.anonymous;
    }
  }

  QuestionStatus get convertQuestionStatus {
    switch (this) {
      case "답변완료": return QuestionStatus.answered;
      case "새질문": return QuestionStatus.newQuestion;
      case "거절질문": return QuestionStatus.rejected;
      default: return QuestionStatus.newQuestion;
    }
  }

  QuestionType get convertQuestionType {
    switch (this) {
      case "개인 활동": return QuestionType.personal;
      case "커뮤니티": return QuestionType.community;
      default: return QuestionType.personal;
    }
  }
}


class QuestionController extends GetxController {
  RxString questionPublicMode = "".obs;
  RxString commentMode = "".obs;
  TextEditingController titleTextController = TextEditingController();
  TextEditingController contentTextController = TextEditingController();
  TextEditingController answerTextController = TextEditingController();
  Rx<SortButtonType> sortType = SortButtonType.latest.obs;

  RxList<QuestionModel> personalQuestionList = <QuestionModel>[].obs;
  RxMap<String, CommentModel> personalQuestionAnswerList = <String, CommentModel>{}.obs;
  List<QuestionModel> userLikeQuestionList = [];
  RxBool isPersonalQuestionListRefreshing = false.obs;

  RxList<QuestionModel> communityQuestionList = <QuestionModel>[].obs;
  RxBool isCommunityQuestionListRefreshing = false.obs;
  RxList<CommentModel> communityCommentList = <CommentModel>[].obs;
  RxBool isCommunityCommentListRefreshing = false.obs;

  RxList<QuestionModel> userAskQuestionList = <QuestionModel>[].obs;
  RxMap<String, CommentModel> userAskQuestionAnswerList = <String, CommentModel>{}.obs;
  RxBool isUserAskQuestionListRefreshing = false.obs;

  RxList<QuestionModel> userBookmarkQuestionList = <QuestionModel>[].obs;
  RxMap<String, CommentModel> userBookmarkQuestionAnswerList = <String, CommentModel>{}.obs;
  RxBool isUserBookmarkQuestionListRefreshing = false.obs;

  SharedPreference _sharedPreference = SharedPreference();
  ImagePicker _imagePicker = Get.find<ImagePicker>();
  UserController _userController = Get.find<UserController>();
  ApiProvider _apiProvider = Get.find<ApiProvider>();

  DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
  DateFormat simpleDateFormat = DateFormat("MM월 dd일 HH시 mm분");

  Rx<XFile?> questionImageFile = XFile("").obs;

  getImageFromDevice(ImageSource sourceKind) async => questionImageFile.value = await _imagePicker.pickImage(source: sourceKind);

  getUserList() async => (await _apiProvider.getAllUserList())['content'];

  uploadNewQuestion(QuestionType questionType, String userId) async {
    QuestionModel newQuestion = QuestionModel(
      questionType: questionType,
      publicMode: questionPublicMode.value.convertQuestionPublicMode,
      content: contentTextController.text,
      author: _userController.user,
      imageLink: questionImageFile.value?.path == "" ? "" : "${_apiProvider.apiUrl}/images/${(await _apiProvider.uploadImageFile(questionImageFile.value))['content']['filename']}"
    );

    Map result = await _apiProvider.askQuestion(newQuestion, userId);

    if (result['success']) {
      _userController.showToast("질문 등록에 성공하였습니다.");
      questionImageFile.value = XFile("");
      contentTextController.text = "";
      questionType == QuestionType.personal ? getUserPersonalQuestionList(Get.find<MainScreenController>().userInUserPage.value.id!) : getCommunityQuestionList();
      Get.back();
    } else {
      _userController.showToast("질문 등록에 실패하였습니다.");
    }
  }

  modifyQuestion(String postId, QuestionType questionType) async {
    Map result = await _apiProvider.modifyQuestion(postId, contentTextController.text);

    questionType == QuestionType.personal ? getUserPersonalQuestionList(Get.find<MainScreenController>().userInUserPage.value.id!) : getCommunityQuestionList();
    _userController.showToast("질문 수정에 ${result['success'] ? "성공" : "실패"}하였습니다.");
    if (result['success']) { contentTextController.text = ""; }
    Get.back();
  }

  removeQuestion(String postId, QuestionType questionType) async {
    Map result = await _apiProvider.removeQuestion(postId);

    questionType == QuestionType.personal ? getUserPersonalQuestionList(Get.find<MainScreenController>().userInUserPage.value.id!) : getCommunityQuestionList();
    _userController.showToast("질문 삭제에 ${result['success'] ? "성공" : "실패"}하였습니다.");
  }

  rejectQuestion(String postId, QuestionType questionType) async {
    Map result = await _apiProvider.rejectQuestion(postId);

    questionType == QuestionType.personal ? getUserPersonalQuestionList(Get.find<MainScreenController>().userInUserPage.value.id!) : getCommunityQuestionList();
    _userController.showToast("질문 거절에 ${result['success'] ? "성공" : "실패"}하였습니다.");
  }

  likeQuestion(String postId, QuestionType questionType) async {
    Map result = await _apiProvider.likeQuestion(postId);

    questionType == QuestionType.personal ? getUserPersonalQuestionList(Get.find<MainScreenController>().userInUserPage.value.id!) : getCommunityQuestionList();
    _userController.showToast("질문 좋아요에 ${result['success'] ? "성공" : "실패"}하였습니다.");
  }

  unlikeQuestion(String postId, QuestionType questionType) async {
    Map result = await _apiProvider.unlikeQuestion(postId);

    questionType == QuestionType.personal ? getUserPersonalQuestionList(Get.find<MainScreenController>().userInUserPage.value.id!) : getCommunityQuestionList();
    _userController.showToast("질문 좋아요 제거에 ${result['success'] ? "성공" : "실패"}하였습니다.");
  }

  bookmarkQuestion(String postId, QuestionType questionType) async {
    Map result = await _apiProvider.bookmarkQuestion(postId);

    questionType == QuestionType.personal ? getUserPersonalQuestionList(Get.find<MainScreenController>().userInUserPage.value.id!) : getCommunityQuestionList();
    _userController.showToast("질문 저장에 ${result['success'] ? "성공" : "실패"}하였습니다.");
    Get.back();
  }

  reportQuestion(String postId, QuestionType questionType, String reason, BuildContext context, dynamic nextDialog) async {
    Map result = await _apiProvider.reportQuestion(postId, reason);

    questionType == QuestionType.personal ? getUserPersonalQuestionList(Get.find<MainScreenController>().userInUserPage.value.id!) : getCommunityQuestionList();

    Get.back();
    if (result['success']) {
      showDialog(
        context: context,
        builder: (_) => nextDialog,
      );
    } else {
      _userController.showToast("질문 신고에 실패하였습니다.");
    }
  }

  shareQuestion(QuestionModel question) async {
    Share.share('질문을 보시고 싶으시다면, Disked 앱에 참여해보세요!\n\n공유한 질문 내용 중 일부: ${question.content!.substring(0, question.content!.length ~/ 2)}⋯');
    Get.back();
  }

  getUserPersonalQuestionList(String userId) async {
    isPersonalQuestionListRefreshing.value = true;
    personalQuestionList.value = (await _apiProvider.getUserPersonalQuestionList(userId))['content'];
    for (var question in personalQuestionList) {
      if (question.answerCount != 0) {
        personalQuestionAnswerList[question.id!] = (await _apiProvider.getCommentInQuestion(question.id!))['content'][0];
      }
    }
    userLikeQuestionList = (await _apiProvider.getUserLikeQuestionList(userId))['content'];
    isPersonalQuestionListRefreshing.value = false;
  }

  getUserAskQuestionList() async {
    isUserAskQuestionListRefreshing.value = true;
    userAskQuestionList.value = (await _apiProvider.getUserAskQuestionList(_userController.user.id!))['content'];

    for (var question in userAskQuestionList) {
      if (question.answerCount != 0) {
        userAskQuestionAnswerList[question.id!] = (await _apiProvider.getCommentInQuestion(question.id!))['content'][0];
      }
    }

    userLikeQuestionList = (await _apiProvider.getUserLikeQuestionList(_userController.user.id!))['content'];

    isUserAskQuestionListRefreshing.value = false;
  }

  getUserBookmarkQuestionList() async {
    isUserBookmarkQuestionListRefreshing.value = true;
    userBookmarkQuestionList.value = (await _apiProvider.getUserBookmarkQuestionList(_userController.user.id!))['content'];

    for (var question in userBookmarkQuestionList) {
      if (question.answerCount != 0) {
        userBookmarkQuestionAnswerList[question.id!] = (await _apiProvider.getCommentInQuestion(question.id!))['content'][0];
      }
    }

    userLikeQuestionList = (await _apiProvider.getUserLikeQuestionList(_userController.user.id!))['content'];

    isUserBookmarkQuestionListRefreshing.value = false;
  }

  getCommunityQuestionList() async {
    isCommunityQuestionListRefreshing.value = true;
    communityQuestionList.value = (await _apiProvider.getUserCommunityQuestionList())['content'];
    userLikeQuestionList = (await _apiProvider.getUserLikeQuestionList(_userController.user.id!))['content'];
    isCommunityQuestionListRefreshing.value = false;
  }

  getCommunityQuestionCommentList(String postId) async {
    isCommunityCommentListRefreshing.value = true;
    communityCommentList.value = (await _apiProvider.getCommentInQuestion(postId))['content'];
    isCommunityCommentListRefreshing.value = false;
  }

  commentToQuestion(String postId, String content, bool isAnony, QuestionType questionType) async {
    Map result = await _apiProvider.commentToQuestion(postId, content, isAnony);

    _userController.showToast("질문 답변에 ${result['success'] ? "성공" : "실패"}하였습니다.");
    if (result['success']) { answerTextController.text = ""; }

    if (questionType == QuestionType.personal) {
      getUserPersonalQuestionList(Get.find<MainScreenController>().userInUserPage.value.id!);
      Get.back();
    } else {
      getCommunityQuestionCommentList(postId);
    }
  }


  getLatestSearchList() {
    List<String>? list = _sharedPreference.getLatestSearchList();

    return list != null ? list.obs : <String>[].obs;
  }

  saveLatestSearchList(List<String> data) async => _sharedPreference.saveLatestSearchList(data);

  removeLatestSearchList() async => _sharedPreference.removeLatestSearchList();
}
