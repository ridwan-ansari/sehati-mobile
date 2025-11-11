class ProfileResponse {
  final int statusCode;
  final String message;
  final ProfileData data;

  ProfileResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      statusCode: json["status_code"],
      message: json["message"],
      data: ProfileData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "data": data.toJson(),
      };
}

class ProfileData {
  final String fullname;
  final String picture;
  final String nickname;
  final String email;
  final String phoneNumber;
  final String gender;
  final String dateOfBirth;

  ProfileData({
    required this.fullname,
    required this.picture,
    required this.nickname,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.dateOfBirth,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      fullname: json["fullname"] ?? "",
      picture: json["picture"] ?? "",
      nickname: json["nickname"] ?? "",
      email: json["email"] ?? "",
      phoneNumber: json["phone_number"] ?? "",
      gender: json["gender"] ?? "",
      dateOfBirth: json["date_of_birth"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "picture": picture,
        "nickname": nickname,
        "email": email,
        "phone_number": phoneNumber,
        "gender": gender,
        "date_of_birth": dateOfBirth,
      };
}