import 'package:flutter_recruit_asked/models/user.dart';
import 'package:get/get.dart';

import '../controllers/question_controller.dart';

class QuestionModel {
  QuestionType? _questionType;
  QuestionPublicMode? _publicMode;
  QuestionStatus? _questionStatus;
  String? _id;
  String? _title;
  String? _content;
  UserModel? _author;
  DateTime? _date;
  String? _imageLink;
  int? _loveCount;
  int? _answerCount;
  bool? _isDeny;

  QuestionType? get questionType => _questionType;
  QuestionPublicMode? get publicMode => _publicMode;
  QuestionStatus? get questionStatus => _questionStatus;
  String? get id => _id;
  String? get title => _title;
  String? get content => _content;
  UserModel? get author => _author;
  DateTime? get date => _date;
  String? get imageLink => _imageLink;
  int? get loveCount => _loveCount;
  int? get answerCount => _answerCount;
  bool? get isDeny => _isDeny;

  QuestionModel({
    required QuestionType questionType,
    required QuestionPublicMode publicMode,
    QuestionStatus? questionStatus,
    String? id,
    String? title,
    required String content,
    required UserModel author,
    DateTime? date,
    String? imageLink,
    int? loveCount,
    int? answerCount,
    bool? isDeny,
  }){
    _questionType = questionType;
    _publicMode = publicMode;
    _questionStatus = questionStatus;
    _id = id;
    _title = title;
    _content = content;
    _author = author;
    _date = date;
    _imageLink = imageLink;
    _loveCount = loveCount;
    _answerCount = answerCount;
    _isDeny = isDeny;
  }

  QuestionModel.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _content = json['content'];
    _publicMode = json['isAnony'] == true ? QuestionPublicMode.anonymous : QuestionPublicMode.public;
    _questionType = json['isCommunity'] == true ? QuestionType.community : QuestionType.personal;
    _imageLink = json['imageLink'];
    _author = json['author'] != null ? UserModel.fromJson(json['author']) : null;
    _date = (Get.find<QuestionController>().dateFormat.parse(json['createdAt'])).add(Duration(hours: 9));
    _loveCount = json['loveCount'];
    _answerCount = json['answerCount'];
    _isDeny = json['denied'];
    _questionStatus = _isDeny! ? QuestionStatus.rejected : (_answerCount! == 0 ? QuestionStatus.newQuestion : QuestionStatus.answered);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isAnony'] = publicMode == QuestionPublicMode.anonymous;
    map['content'] = content;
    map['imageLink'] = imageLink;

    return map;
  }
}
