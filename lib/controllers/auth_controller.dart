import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/screens/auth/register_userinfo.dart';
import 'package:flutter_recruit_asked/services/api_provider.dart';
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
  Map loginUserInfo = {};
  RxString selectGroupName = "init".obs;

  TextEditingController nicknameTextController = TextEditingController();
  TextEditingController idTextController = TextEditingController();
  GlobalKey<FormState> nicknameFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> idFormKey = new GlobalKey<FormState>();
  final FocusNode nicknameFocus = new FocusNode();
  final FocusNode idFocus = new FocusNode();

  RxBool isLogin = false.obs;

  final Dio _dio = Get.find<Dio>();
  ApiProvider _apiProvider = Get.find<ApiProvider>();

  @override
  onInit() async {
    super.onInit();
    _firebaseUser.bindStream(authInstance.authStateChanges());
    _firebaseUser.value = authInstance.currentUser;
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

    loginUserInfo["type"] = "G";
    loginUserInfo["userid"] = _authResult.user?.uid;
    loginUserInfo["email"] = googleUser?.email;
    loginUserInfo["name"] = googleUser?.displayName;
    loginUserInfo["profileImgUrl"] = googleUser?.photoUrl;

    if (_authResult.additionalUserInfo!.isNewUser) {
      Get.to(RegisterUserInfo());
    } else {
      await _apiProvider.userLogin("google", loginUserInfo["userid"]);
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

      loginUserInfo["type"] = "K";
      loginUserInfo["userid"] = "kakao:${user.id}";
      loginUserInfo["email"] = user.kakaoAccount!.email;
      loginUserInfo["name"] = user.kakaoAccount!.profile!.nickname;
      loginUserInfo["profileImgUrl"] = user.kakaoAccount!.profile!.profileImageUrl;

      Get.find<UserController>().showToast("카카오 로그인 중입니다.\n카카오톡 연동에 시간이 걸리니 잠시만 기다려주세요.");

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

      if (await _apiProvider.isKakaoAccountAlreadySignUp(loginUserInfo["userid"])) {
        await _apiProvider.userLogin("kakao", loginUserInfo["userid"]);
        isLogin.value = true;
      } else {
        Get.to(RegisterUserInfo());
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
      firebaseAuthId: loginUserInfo["userid"],
      email: loginUserInfo["email"],
      name: loginUserInfo["name"],
      profileImg: loginUserInfo["profileImgUrl"],
      linkId: loginUserInfo['linkId'],
      type: loginUserInfo['type']
    );

   await Get.find<ApiProvider>().userSignUp(_user);
  }
}
