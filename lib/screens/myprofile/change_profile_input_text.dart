import 'package:flutter/material.dart';
import 'package:flutter_recruit_asked/controllers/user_controller.dart';
import 'package:get/get.dart';

import '../../services/check_text_validate.dart';
import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

class ChangeProfileInputText extends GetWidget<UserController> {
  final String textType;
  final int lengthLimit;
  TextEditingController textEditingController;
  FocusNode focusNode;
  ChangeProfileInputText({required this.textType, required this.lengthLimit, required this.textEditingController, required this.focusNode});

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    controller.changeTextLength.value = textEditingController.text.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: _width, height: _height * 0.04),
                Positioned(top: _height * 0.01, child: Text("프로필 $textType", style: appBarTitle)),
                Positioned(
                  top: _height * 0.01,
                  left: _width * 0.075,
                  child: GestureDetector(onTap: () => Get.back(), child: Icon(Icons.arrow_back_ios_sharp, size: 24)),
                ),
                Positioned(
                  top: _height * 0.01,
                  right: _width * 0.075,
                  child: GestureDetector(
                    onTap: () {
                      if (controller.formKey.currentState!.validate()) {  Get.back(); }
                    },
                    child: Text("저장", style: changeProfileSaveBtn)
                  ),
                )
              ],
            ),
            SizedBox(height: _height * 0.0075),
            Divider(color: grayFive, thickness: 1),
            SizedBox(height: _height * 0.02),
            SizedBox(
              width: _width * 0.875,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(textType, style: changeProfileChangeTextTitle),
                  Obx(() => Text("${controller.changeTextLength.value}/$lengthLimit", style: changeProfileChangeTextLength))
                ],
              ),
            ),
            SizedBox(
              width: _width * 0.875,
              child: Form(
                key: controller.formKey,
                child: TextFormField(
                  minLines: 1,
                  maxLines: 1,
                  controller: textEditingController,
                  focusNode: focusNode,
                  keyboardType: TextInputType.text,
                  style: changeProfileChangeTextField,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: _height * 0.02),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0, style: BorderStyle.none,)),
                      hintText: "여기에 내용을 입력하세요.",
                      hintStyle: changeProfileChangeTextField.copyWith(color: grayOne)
                  ),
                  onChanged: (value) {
                    controller.changeTextLength.value = textEditingController.text.length;
                    controller.formKey.currentState!.validate();
                  },
                  validator: (value) => CheckTextValidate().validateTextLength(focusNode, value!, 0, lengthLimit),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}