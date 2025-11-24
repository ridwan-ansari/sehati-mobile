class LeaderboardModel {
  final String nickname;
  final int achievementPoints;
  final int creditPoints;

  LeaderboardModel({
    required this.nickname,
    required this.achievementPoints,
    required this.creditPoints,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      nickname: json['nickname'],
      achievementPoints: json['achievement_points'],
      creditPoints: json['credit_points'],
    );
  }
}
