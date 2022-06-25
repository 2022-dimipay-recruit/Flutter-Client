class UserModel {
  String? _id;
  String? _firebaseAuthId;
  String? _name;
  String? _email;
  String? _profileImg;
  String? _linkId;
  String? _description;
  int? _followers;
  String? _type;

  String? get id => _id;
  String? get firebaseAuthId => _firebaseAuthId;
  String? get name => _name;
  String? get email => _email;
  String? get profileImg => _profileImg;
  String? get linkId => _linkId;
  String? get description => _description;
  int? get followers => _followers;
  String? get type => _type;

  UserModel({
    String? id,
    String? firebaseAuthId,
    String? name,
    String? email,
    String? profileImg,
    String? linkId,
    String? description,
    int? followers,
    String? type
  }){
    _id = id;
    _firebaseAuthId = firebaseAuthId;
    _name = name;
    _email = email;
    _profileImg = profileImg;
    _linkId = linkId;
    _description = description;
    _followers = followers;
    _type = type;
  }

  UserModel.fromJson(dynamic json) {
    _id = json['id'];
    _firebaseAuthId = json['googleUid'] ?? json['kakaoUid'];
    _name = json['nickname'];
    _email = json['email'];
    _profileImg = json['profileImage'];
    _linkId = json['link'];
    _description = json['description'];
    _followers = json['followers'];
    _type = json['googleUid'] == null || json['googleUid'] == "" ? "K" : "G";
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['${_type == "G" ? "google" : "kakao"}Uid'] = _firebaseAuthId;
    map['nickname'] = _name;
    map['email'] = _email;
    map['profileImage'] = _profileImg;
    map['link'] = _linkId;
    map['description'] = _description ?? "";
    map['followers'] = _followers ?? 0;

    return map;
  }
}
