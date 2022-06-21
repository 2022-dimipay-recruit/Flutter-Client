import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/screens/auth/register_userinfo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao_flutter_lib;

import '../models/user.dart';
import '../controllers/user_controller.dart';

class AuthController extends GetxController {
  FirebaseAuth authInstance = FirebaseAuth.instance;

  final Rxn<User> _firebaseUser = Rxn<User>();
  User? get user => _firebaseUser.value;
  Map loginUserInfo = {}; //userID, email, name, profileImgUrl
  RxString selectGroupName = "init".obs;

  TextEditingController nicknameTextController = TextEditingController();
  TextEditingController idTextController = TextEditingController();

  RxBool isLogin = false.obs;

  final Dio _dio = Get.find<Dio>();

  @override
  onInit() async {
    super.onInit();
    _firebaseUser.bindStream(authInstance.authStateChanges());
    _firebaseUser.value = authInstance.currentUser;
    if (user != null) {
      //Get.find<UserController>().user = await FirestoreDatabase().getUser(user!.uid);
      //TODO 백엔드에서 유저 불러오는 코드 추가
    }
  }

  void signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential _authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);

    loginUserInfo["userid"] = _authResult.user?.uid;
    loginUserInfo["email"] = googleUser?.email;
    loginUserInfo["name"] = googleUser?.displayName;
    loginUserInfo["profileImgUrl"] = googleUser?.photoUrl;

    if (_authResult.additionalUserInfo!.isNewUser) {
      Get.to(RegisterUserInfo());
    } else {
      writeAccountInfo();
      isLogin.value = true;
    }
  }

  void signInWithKakao() async {
    try {
      final installed = await kakao_flutter_lib.isKakaoTalkInstalled();
      kakao_flutter_lib.OAuthToken loginToken = installed
          ? await kakao_flutter_lib.UserApi.instance.loginWithKakaoTalk()
          : await kakao_flutter_lib.UserApi.instance.loginWithKakaoAccount();

      kakao_flutter_lib.User user =
          await kakao_flutter_lib.UserApi.instance.me();

      loginUserInfo["userid"] = "kakao:${user.id}";
      loginUserInfo["email"] = user.kakaoAccount!.email;
      loginUserInfo["name"] = user.kakaoAccount!.profile!.nickname;
      loginUserInfo["profileImgUrl"] = user.kakaoAccount!.profile!.profileImageUrl;

      late Response response;
      try {
        response = await _dio.post('https://dprc.tilto.kr/login/kakao',
            data: {"access_token": loginToken.accessToken});
      } on DioError catch (e) {
        Fluttertoast.showToast(
            msg: "오류가 발생했습니다.\n다시 시도해주세요.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xE6FFFFFF),
            textColor: Colors.black,
            fontSize: 13.0);
      }

      UserCredential _authResult = await FirebaseAuth.instance
          .signInWithCustomToken(response.data['data']['token']);

      if (_authResult.additionalUserInfo!.isNewUser) {
        Get.to(RegisterUserInfo());
      } else {
        writeAccountInfo();
        isLogin.value = true;
      }
    } catch (e) {
      if (e.toString().contains("User canceled login.")) {
        Fluttertoast.showToast(
            msg: "카카오 로그인을 취소하셨습니다.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xE6FFFFFF),
            textColor: Colors.black,
            fontSize: 13.0);
      } else {
        print(e);
      }
    }
  }

  void logOut() async {
    try {
      await authInstance.signOut();

      Get.find<UserController>().clear();

      isLogin.value = false;

      Fluttertoast.showToast(
          msg: "로그아웃 되었습니다.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xE6FFFFFF),
          textColor: Colors.black,
          fontSize: 13.0);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "로그아웃 오류",
        e.message ?? "예기치 못한 오류가 발생하였습니다.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void writeAccountInfo() async {
    UserModel _user = UserModel(
      id: loginUserInfo["userid"],
      email: loginUserInfo["email"],
      name: loginUserInfo["name"],
      profileImg: loginUserInfo["profileImgUrl"],
      linkId: loginUserInfo['linkId'],
    );

    Get.find<UserController>().user = _user;
  }
}
