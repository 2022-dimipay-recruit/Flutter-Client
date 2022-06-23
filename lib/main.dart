import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_recruit_asked/services/shared_preference.dart';
import 'package:flutter_recruit_asked/themes/color_theme.dart';
import 'package:flutter_recruit_asked/token_reference.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'utils/root.dart';
import 'controllers/bindings/main_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  KakaoSdk.init(nativeAppKey: TokenReference().kakaoNativeKey);
  SharedPreference();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));

    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: grayTwo,
          secondary: grayTwo,
        ),
      ),
      builder: (context, child) => Scaffold(
        // 화면 클릭 시, 키보드 숨기기
        body: GestureDetector(
          onTap: () {
            hideKeyboard(context);
          },
          child: child,
        ),
      ),
      initialBinding: MainBinding(),
      home: const Root());
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
