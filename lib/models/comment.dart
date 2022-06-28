import 'package:flutter_recruit_asked/models/user.dart';
import 'package:get/get.dart';

import '../controllers/question_controller.dart';

class CommentModel {
  String? _id;
  String? _postId;
  String? _authorId;
  UserModel? _author;
  String? _content;
  DateTime? _date;
  bool? _isAnony;

  String? get id => _id;
  String? get postId => _postId;
  String? get authorId => _authorId;
  UserModel? get author => _author;
  String? get content => _content;
  DateTime? get date => _date;
  bool? get isAnony => _isAnony;

  CommentModel({
    String? id,
    String? postId,
    String? authorId,
    UserModel? author,
    String? content,
    DateTime? date,
    bool? isAnony,
  }){
    _id = id;
    _postId = postId;
    _authorId = authorId;
    _author = author;
    _content = content;
    _date = date;
    _isAnony = isAnony;
  }

  CommentModel.fromJson(dynamic json) {
    _id = json['id'];
    _postId = json['postId'];
    _authorId = json['authorId'];
    _author = json['author'];
    _content = json['content'];
    _date = (Get.find<QuestionController>().dateFormat.parse(json['createdAt'])).add(Duration(hours: 9));
    _isAnony = json['isAnony'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['postId'] = _postId;
    map['authorId'] = _authorId;
    map['author'] = _author;
    map['content'] = _content;
    map['date'] = _date;
    map['isAnony'] = _isAnony;

    return map;
  }
}
