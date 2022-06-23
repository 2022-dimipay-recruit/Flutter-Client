import '../controllers/question_controller.dart';

class QuestionModel {
  QuestionType questionType;
  QuestionPublicMode publicMode;
  QuestionStatus? questionStatus;
  String? title;
  String content;
  String author;
  String date;

  QuestionModel({required this.questionType, required this.publicMode, this.questionStatus, this.title, required this.content, required this.author, required this.date});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['questionType'] = questionType;
    map['publicMode'] = publicMode;
    map['questionStatus'] = questionStatus;
    map['title'] = title;
    map['content'] = content;
    map['author'] = author;
    map['date'] = date;

    return map;
  }
}
