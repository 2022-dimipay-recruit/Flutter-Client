class CommentModel {
  String content;
  String author;
  String date;

  CommentModel({required this.content, required this.author, required this.date});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['content'] = content;
    map['author'] = author;
    map['date'] = date;

    return map;
  }
}
