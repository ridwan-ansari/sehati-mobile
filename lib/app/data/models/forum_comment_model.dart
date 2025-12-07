class ForumComment {
  final String comment;
  final String createdAt;
  final String nickname;
  final String picture;

  ForumComment({
    required this.comment,
    required this.createdAt,
    required this.nickname,
    required this.picture,
  });

  factory ForumComment.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};

    return ForumComment(
      comment: json['comment'] ?? "",
      createdAt: json['created_at'] ?? "",
      nickname: user['nickname'] ?? "Unknown User",
      picture: user['picture'] ?? "",
    );
  }
}
