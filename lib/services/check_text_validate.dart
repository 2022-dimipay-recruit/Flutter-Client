import 'package:flutter/material.dart';

class CheckTextValidate {
  String? validateTextLength(FocusNode focusNode, String value, int lengthMinLimit, int lengthMaxLimit) {
    if(value.length > lengthMaxLimit) {
      focusNode.requestFocus();
      return '글자 수 제한을 넘어갔습니다.';
    } else if (value.length < lengthMinLimit) {
      focusNode.requestFocus();
      return '최소 글자 수 조건($lengthMinLimit글자 이상)을 충족해주세요.';
    } else {
      return null;
    }
  }
}