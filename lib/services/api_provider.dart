import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:flutter_recruit_asked/models/question.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response, MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';

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
      Response response = await _dio.post(
          "$apiUrl/users",
          options: Options(contentType: "application/json"),
          data: user.toJson()
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
      await storeUserData(authResponse.data['data']['userId']);

      return true;
    } catch (e) {
      return false;
    }
  }

  checkNowLogin() async => (await loadSavedToken()) != null;

  loadSavedToken() async => await _storage.read(key: "diskedAccount_accessToken");

  fetchAccountData() async {
    if (!(await validateAccessToken())) { await refreshAccessToken(); }

    bool isSuccessStoreData = await storeUserData((await _storage.read(key: "diskedAccount_userId"))!);
    if (!isSuccessStoreData) { _userController.user = UserModel.fromJson(json.decode((await _storage.read(key: "diskedAccount_userInfo"))!)); }
  }

  validateAccessToken() async {
    String? accessToken = await _storage.read(key: "diskedAccount_accessToken");
    try {
      await _dio.get(
        "$apiUrl/user/me",
        options: Options(contentType: "application/json", headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return true;
    } catch (e) {
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

  storeUserData(String uid) async {
    try {
      Response infoResponse = await _dio.get(
        "$apiUrl/users/id/$uid",
        options: Options(contentType: "application/json",
            headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      Map data = infoResponse.data['data'][0];
      data['followers'] = ((await getFollowerUserList(uid))['content'] as List).length;

      _userController.user = UserModel.fromJson(data);
      await _storage.write(key: "diskedAccount_userInfo", value: json.encode(_userController.user.toJson()));

      return true;
    } on DioError catch (e) {
      return false;
    }
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
}