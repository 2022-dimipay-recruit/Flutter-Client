import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_recruit_asked/controllers/mainscreen_controller.dart';
import 'package:flutter_recruit_asked/controllers/question_controller.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/models/question.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response, MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';

import '../models/alert.dart';
import '../models/comment.dart';
import '../models/user.dart';

class ApiProvider {
  final apiUrl = "https://dprc.tilto.kr";
  final Dio _dio = Get.find<Dio>();
  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();
  UserController _userController = Get.find<UserController>();

  late String _accessToken;



  initUserInfo() async {
    if (await checkNowLogin()) {
      _accessToken = await loadSavedToken();

      await fetchAccountData();
    }
  }

  userSignUp(UserModel user) async {
    try {
      Map userData = user.toJson();
      userData.remove('followers');
      userData.remove('id');

      Response response = await _dio.post(
          "$apiUrl/users",
          options: Options(contentType: "application/json"),
          data: userData
      );

      await userLogin(user.type! == "G" ? "google" : "kakao", user.firebaseAuthId!);

      return {
        "success": true,
        "content": response.data['data']
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  userLogin(String accountKind, String uuid) async {
    try {
      Response authResponse = await _dio.post(
        '$apiUrl/auth/login',
        options: Options(contentType: "application/json"),
        data: {"${accountKind}Uid": uuid},
      );

      _accessToken = authResponse.data['data']['accessToken'];
      await _storage.write(key: "diskedAccount_accessToken", value: authResponse.data['data']['accessToken']);
      await _storage.write(key: "diskedAccount_refreshToken", value: authResponse.data['data']['refreshToken']);
      await _storage.write(key: "diskedAccount_userId", value: authResponse.data['data']['userId']);
      await getUserData(authResponse.data['data']['userId'], true);

      return {
        "success": true,
        "content": authResponse.data['data']
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  checkNowLogin() async => (await loadSavedToken()) != null;

  loadSavedToken() async => await _storage.read(key: "diskedAccount_accessToken");

  fetchAccountData() async {
    if (!(await validateAccessToken())) { await refreshAccessToken(); }

    bool isSuccessStoreData = (await getUserData((await _storage.read(key: "diskedAccount_userId"))!, true))['success'];
    if (!isSuccessStoreData) {
      UserModel user = UserModel.fromJson(json.decode((await _storage.read(key: "diskedAccount_userInfo"))!));
      _userController.user = user;
      Get.find<MainScreenController>().userInUserPage.value = user;
    }
  }

  validateAccessToken() async {
    String? accessToken = await _storage.read(key: "diskedAccount_accessToken");
    String? userId = await _storage.read(key: "diskedAccount_userId");
    try {
      await _dio.get(
        "$apiUrl/users/id/$userId",
        options: Options(contentType: "application/json", headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return true;
    } on DioError catch (e) {
      return false;
    }
  }

  refreshAccessToken() async {
    try {
      String? refreshToken = await _storage.read(key: "diskedAccount_refreshToken");

      Response response = await _dio.post(
        '$apiUrl/auth/token',
        options: Options(contentType: "application/json"),
        data: {
          "refreshToken": refreshToken,
        }
      );

      _accessToken = response.data['data']['accessToken'];
      await _storage.write(key: "diskedAccount_accessToken", value: response.data['data']['accessToken']);


      return true;
    } catch (e) {
      return false;
    }
  }

  isKakaoAccountAlreadySignUp(String uuid) async {
    try {
      Response authResponse = await _dio.post(
        '$apiUrl/auth/login',
        options: Options(contentType: "application/json"),
        data: {"kakaoUid": uuid},
      );

      return true;
    } on DioError catch (e) {
      return false;
    }
  }

  getUserData(String uid, bool isMyData) async {
    try {
      Response infoResponse = await _dio.get(
        "$apiUrl/users/id/$uid",
        options: Options(contentType: "application/json",
            headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      Map data = infoResponse.data['data'][0];
      data['followers'] = ((await getFollowerUserList(uid))['content'] as List).length;

      if (isMyData) { await storeUserData(data); }

      return {
        "success": true,
        "content": data
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  storeUserData(Map userMapData) async {
    UserModel user = UserModel.fromJson(userMapData);
    _userController.user = user;
    Get.find<MainScreenController>().userInUserPage.value = user;
    await _storage.write(key: "diskedAccount_userInfo", value: json.encode(_userController.user.toJson()));
  }

  updateUserProfile(UserModel user) async {
    try {
      Response response = await _dio.patch(
        "$apiUrl/users/id/${user.id!}",
        options: Options(contentType: "application/json",
            headers: {'Authorization': 'Bearer $_accessToken'}),
        data: {
          'nickname': user.name!,
          'description': user.description!,
        },
      );

      return {
        "success": true,
        "content": response.data['data']
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  followOtherUser(String id) async {
    try {
      Response response = await _dio.post(
          "$apiUrl/follows/$id/follow",
          options: Options(contentType: "application/json",
              headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      return {
        "success": true,
        "content": response.data['data']
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  unfollowOtherUser(String id) async {
    try {
      Response response = await _dio.delete(
        "$apiUrl/follows/$id/follow",
        options: Options(contentType: "application/json",
            headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      return {
        "success": true,
        "content": response.data['data']
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  getFollowerUserList(String id) async {
    try {
      Response response = await _dio.get(
        "$apiUrl/follows/$id/follower",
        options: Options(contentType: "application/json",
            headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      return {
        "success": true,
        "content": response.data['data']
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  getFollowingUserList(String id) async {
    try {
      Response response = await _dio.get(
        "$apiUrl/follows/$id/following",
        options: Options(contentType: "application/json",
            headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      List originalData = response.data['data'];
      List<UserModel> formattingData = [];
      originalData.forEach((element) => formattingData.add(UserModel.fromJson(element)));

      return {
        "success": true,
        "content": formattingData
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  getAllUserList() async {
    try {
      Response response = await _dio.get(
        "$apiUrl/users",
        options: Options(contentType: "application/json",
            headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      List originalData = response.data['data'];
      List<UserModel> formattingData = [];
      for (var user in originalData) {
        user['followers'] = ((await getFollowerUserList(user['id']))['content'] as List).length;
        formattingData.add(UserModel.fromJson(user));
      }

      return {
        "success": true,
        "content": formattingData
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  commentToQuestion(String postId, String content, bool isAnony) async {
    try {
      Response response = await _dio.post(
        "$apiUrl/answers/create",
        options: Options(contentType: "application/json",
            headers: {'Authorization': 'Bearer $_accessToken'}),
        data: {
          "postId": postId,
          "content": content,
          "isAnony": isAnony
        }
      );

      return {
        "success": true,
        "content": response.data['data']
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  getCommentInQuestion(String postId) async {
    try {
      Response response = await _dio.get(
          "$apiUrl/answers/get/post/$postId",
          options: Options(contentType: "application/json",
              headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      List originalData = response.data['data'];
      List<CommentModel> formattingData = [];
      for (var question in originalData) {
        question['author'] = UserModel.fromJson((await getUserData(question['authorId'], false))['content']);
        formattingData.add(CommentModel.fromJson(question));
      }

      return {
        "success": true,
        "content": formattingData
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  getUserPersonalQuestionList(String id) async {
    try {
      Response response = await _dio.get(
        "$apiUrl/posts/userId/$id",
        options: Options(contentType: "application/json",
            headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      List originalData = response.data['data'];
      List<QuestionModel> formattingData = [];
      originalData.forEach((element) => formattingData.add(QuestionModel.fromJson(element)));

      return {
        "success": true,
        "content": formattingData
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  getUserCommunityQuestionList() async {
    try {
      Response response = await _dio.get(
        "$apiUrl/posts/public",
        options: Options(contentType: "application/json",
            headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      List originalData = response.data['data'];
      List<QuestionModel> formattingData = [];
      originalData.forEach((element) => formattingData.add(QuestionModel.fromJson(element)));

      return {
        "success": true,
        "content": formattingData
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  getUserLikeQuestionList(String userId) async {
    try {
      Response response = await _dio.get(
        "$apiUrl/users/$userId/loves",
        options: Options(contentType: "application/json",
            headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      List originalData = response.data['data'];
      List<QuestionModel> formattingData = [];
      originalData.forEach((element) => formattingData.add(QuestionModel.fromJson(element)));

      return {
        "success": true,
        "content": formattingData
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  getUserAskQuestionList(String userId) async {
    try {
      Response response = await _dio.get(
        "$apiUrl/posts/userId/$userId",
        options: Options(contentType: "application/json",
            headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      List originalData = response.data['data'];
      List<QuestionModel> formattingData = [];
      for (var question in originalData) {
        formattingData.add(QuestionModel.fromJson(question));
      }

      return {
        "success": true,
        "content": formattingData
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  getUserBookmarkQuestionList(String userId) async {
    try {
      Response response = await _dio.get(
        "$apiUrl/users/$userId/bookmarks",
        options: Options(contentType: "application/json",
            headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      List originalData = response.data['data'];
      List<QuestionModel> formattingData = [];
      for (var question in originalData) {
        question['author'] = (await getUserData(question['authorId'], false))['content'];
        formattingData.add(QuestionModel.fromJson(question));
      }

      return {
        "success": true,
        "content": formattingData
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  uploadImageFile(XFile? imageXFile) async {
    try {
      File imageFile = File(imageXFile!.path);

      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "img": await MultipartFile.fromFile(imageFile.path, filename:fileName),
      });

      Response response = await _dio.post(
        "$apiUrl/uploads/image/single",
        options: Options(contentType: "multipart/form-data",
            headers: {'Authorization': 'Bearer $_accessToken'}),
        data: formData,
      );

      return {
        "success": true,
        "content": response.data['data']
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }


  askQuestion(QuestionModel question, String userId) async {
    try {
      Response response = await _dio.post(
          "$apiUrl/posts/${question.questionType == QuestionType.community ? "public" : "userId/$userId"}",
          options: Options(contentType: "application/json", headers: {'Authorization': 'Bearer $_accessToken'}),
          data: question.toJson()
      );

      return {
        "success": true,
        "content": response.data['data']
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  modifyQuestion(String postId, String content) async {
    try {
      Response response = await _dio.patch(
        "$apiUrl/posts/$postId",
        options: Options(contentType: "application/json", headers: {'Authorization': 'Bearer $_accessToken'}),
        data: {
          "content": content,
        }
      );

      return {
        "success": true,
        "content": response.data['data']
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  removeQuestion(String postId) async {
    try {
      Response response = await _dio.delete(
          "$apiUrl/posts/$postId",
          options: Options(contentType: "application/json", headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      return {
        "success": true,
        "content": response.data['data']
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  rejectQuestion(String postId) async {
    try {
      Response response = await _dio.post(
        "$apiUrl/posts/$postId/deny",
        options: Options(contentType: "application/json", headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      return {
        "success": true,
        "content": response.data['data']
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  likeQuestion(String postId) async {
    try {
      Response response = await _dio.post(
        "$apiUrl/posts/$postId/love",
        options: Options(contentType: "application/json", headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      return {
        "success": true,
        "content": response.data['data']
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  unlikeQuestion(String postId) async {
    try {
      Response response = await _dio.delete(
        "$apiUrl/posts/$postId/love",
        options: Options(contentType: "application/json", headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      return {
        "success": true,
        "content": response.data['data']
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  bookmarkQuestion(String postId) async {
    try {
      Response response = await _dio.post(
        "$apiUrl/posts/$postId/bookmark",
        options: Options(contentType: "application/json", headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      return {
        "success": true,
        "content": response.data['data']
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  reportQuestion(String postId, String reportReason) async {
    try {
      Response response = await _dio.post(
        "$apiUrl/posts/$postId/report",
        options: Options(contentType: "application/json", headers: {'Authorization': 'Bearer $_accessToken'}),
        data: {"reason": reportReason}
      );

      return {
        "success": true,
        "content": response.data['data']
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }


  getUserAlertList() async {
    try {
      Response response = await _dio.get(
          "$apiUrl/notify",
          options: Options(contentType: "application/json", headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      List originalData = response.data['data'];
      List<AlertModel> formattingData = [];
      originalData.forEach((element) => formattingData.add(AlertModel.fromJson(element)));

      return {
        "success": true,
        "content": formattingData,
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  changeReadStatusAlert(String id) async {
    try {
      Response response = await _dio.patch(
        "$apiUrl/notify/$id",
        options: Options(contentType: "application/json", headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      return {
        "success": true,
        "content": response.data['data'],
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }

  removeAlert(String id) async {
    try {
      Response response = await _dio.delete(
        "$apiUrl/notify/$id",
        options: Options(contentType: "application/json", headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      return {
        "success": true,
        "content": response.data['data'],
      };
    } on DioError catch (e) {
      return {
        "success": false,
        "content": e.response?.data['data']["message"]
      };
    }
  }
}