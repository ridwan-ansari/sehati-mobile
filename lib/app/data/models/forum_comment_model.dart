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
    return ForumComment(
      comment: json['comment'],
      createdAt: json['created_at'],
      nickname: json['user']['nickname'],
      picture: json['user']['picture'],
    );
  }
}
