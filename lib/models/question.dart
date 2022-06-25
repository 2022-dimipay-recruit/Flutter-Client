import '../controllers/question_controller.dart';

class QuestionModel {
  QuestionType? _questionType;
  QuestionPublicMode? _publicMode;
  QuestionStatus? _questionStatus;
  String? _title;
  String? _content;
  String? _author;
  String? _date;
  String? _imageLink;
  int? _loveCount;

  QuestionType? get questionType => _questionType;
  QuestionPublicMode? get publicMode => _publicMode;
  QuestionStatus? get questionStatus => _questionStatus;
  String? get title => _title;
  String? get content => _content;
  String? get author => _author;
  String? get date => _date;
  String? get imageLink => _imageLink;
  int? get loveCount => _loveCount;

  QuestionModel({
    required QuestionType questionType,
    required QuestionPublicMode publicMode,
    QuestionStatus? questionStatus,
    String? title,
    required String content,
    required String author,
    required String date,
    String? imageLink,
    int? loveCount,
  }){
    _questionType = questionType;
    _publicMode = publicMode;
    _questionStatus = questionStatus;
    _title = title;
    _content = content;
    _author = author;
    _date = date;
    _imageLink = imageLink;
    _loveCount = loveCount;
  }

  QuestionModel.fromJson(dynamic json) {
    _title = json['title'];
    _content = json['content'];
    _publicMode = json['isAnnony'] == true ? QuestionPublicMode.anonymous : QuestionPublicMode.public;
    _questionType = json['questionType'] == 'isCommunity' ? QuestionType.community : QuestionType.personal;
    _imageLink = json['imageLink'];
    _author = json['author'];
    _date = json['createdAt'];
    _loveCount = json['loveCount'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isAnnony'] = publicMode;
    map['title'] = title;
    map['content'] = content;
    map['imageLink'] = imageLink;

    return map;
  }
}
