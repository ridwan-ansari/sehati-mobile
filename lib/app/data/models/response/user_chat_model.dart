class UserChatModel {
  final String id;
  final String fullname;
  final String picture;
  final String nickname;
  final String? tokenFcm;

  UserChatModel({
    required this.id,
    required this.fullname,
    required this.picture,
    required this.nickname,
    this.tokenFcm,
  });

  factory UserChatModel.fromJson(Map<String, dynamic> json) {
    return UserChatModel(
      id: json['id'] ?? '',
      fullname: json['fullname'] ?? '',
      picture: json['picture'] ?? '',
      nickname: json['nickname'] ?? '',
      tokenFcm: json['token_fcm'],
    );
  }
  static List<UserChatModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => UserChatModel.fromJson(json)).toList();
  }
}