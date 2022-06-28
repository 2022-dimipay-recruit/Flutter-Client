import 'package:flutter_recruit_asked/models/user.dart';
import 'package:get/get.dart';

import '../controllers/alert_controller.dart';
import '../controllers/question_controller.dart';

class AlertModel {
  String? _id;
  String? _linkedId;
  String? _userId;
  AlertType? _type;
  String? _content;
  DateTime? _date;
  bool? _isRead;

  String? get id => _id;
  String? get linkedId => _linkedId;
  String? get userId => _userId;
  AlertType? get type => _type;
  String? get content => _content;
  DateTime? get date => _date;
  bool? get isRead => _isRead;

  CommentModel({
    String? id,
    String? linkedId,
    String? userId,
    AlertType? type,
    String? content,
    DateTime? date,
    bool? isRead,
  }){
    _id = id;
    _linkedId = linkedId;
    _userId = userId;
    _type = type;
    _content = content;
    _date = date;
    _isRead = isRead;
  }

  AlertModel.fromJson(dynamic json) {
    _id = json['id'];
    _linkedId = json['linkedId'];
    _userId = json['userId'];
    _type = json['type'].toString().convertAlertType;
    _content = json['content'];
    _date = (Get.find<QuestionController>().dateFormat.parse(json['createdAt'])).add(Duration(hours: 9));
    _isRead = json['isRead'];
  }
}
