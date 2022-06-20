import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class QuestionController extends GetxController {
  RxString questionMode = "".obs;
  TextEditingController titleTextController = TextEditingController();
  TextEditingController contentTextController = TextEditingController();

  ImagePicker _imagePicker = Get.find<ImagePicker>();
  Rx<XFile?> questionImageFile = XFile("").obs;

  getImageFromDevice(ImageSource sourceKind) async => questionImageFile.value = await _imagePicker.pickImage(source: sourceKind);
}
