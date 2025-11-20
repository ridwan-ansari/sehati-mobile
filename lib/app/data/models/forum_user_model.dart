class ForumUserModel {
  final String id;
  final String nickname;
  final String picture;

  ForumUserModel({
    required this.id,
    required this.nickname,
    required this.picture,
  });

  factory ForumUserModel.fromJson(Map<String, dynamic> json) {
    return ForumUserModel(
      id: json['id'] ?? '',
      nickname: json['nickname'] ?? '',
      picture: json['picture'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'picture': picture,
    };
  }
}
