enum QuestionType {
  personal,
  community
}

enum QuestionPublicMode {
  anonymous,
  public
}

extension QuestionPublicModeExtension on QuestionPublicMode {
  String get convertStr {
    switch (this) {
      case QuestionPublicMode.anonymous: return "익명";
      case QuestionPublicMode.public: return "공개";
      default: return "";
    }
  }
}

class QuestionModel {
  QuestionType questionType;
  QuestionPublicMode publicMode;
  String? title;
  String content;
  String author;
  String date;

  QuestionModel({required this.questionType, required this.publicMode, this.title, required this.content, required this.author, required this.date});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['questionType'] = questionType;
    map['publicMode'] = publicMode;
    map['title'] = title;
    map['content'] = content;
    map['author'] = author;
    map['date'] = date;

    return map;
  }
}
