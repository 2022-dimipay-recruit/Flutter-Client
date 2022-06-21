import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? profileImg;
  String? linkId;
  String? description;
  int? followers;

  UserModel({this.id, this.name, this.email, this.profileImg, this.linkId, this.description, this.followers});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['profileImg'] = profileImg;
    map['linkId'] = linkId;
    map['description'] = description;
    map['followers'] = followers;

    return map;
  }
}
