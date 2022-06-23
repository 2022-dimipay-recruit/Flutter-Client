import 'package:flutter/material.dart';

class CheckTextValidate {
  String? validateTextLength(FocusNode focusNode, String value, int lengthLimit) {
    if(value.length > lengthLimit) {
      focusNode.requestFocus();
      return '글자 수 제한을 넘어갔습니다.';
    } else {
      return null;
    }
  }
}