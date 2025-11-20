import 'forum_user_model.dart';

class ForumContentModel {
  String id;
  int likeCount;
  String createdAt;
  String imageUrl;
  String caption;
  bool isLiked;
  int commentCount;
  ForumUserModel user;

  ForumContentModel({
    required this.id,
    required this.likeCount,
    required this.createdAt,
    required this.imageUrl,
    required this.caption,
    required this.isLiked,
    required this.commentCount,
    required this.user,
  });

  factory ForumContentModel.fromJson(Map<String, dynamic> json) {
    return ForumContentModel(
      id: json['id'] ?? '',
      likeCount: json['like_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      imageUrl: json['image_url'] ?? '',
      caption: json['caption'] ?? '',
      isLiked: json['is_liked'] ?? false,
      commentCount: json['comment_count'] ?? 0,
      user: ForumUserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'like_count': likeCount,
      'created_at': createdAt,
      'image_url': imageUrl,
      'caption': caption,
      'is_liked': isLiked,
      'comment_count': commentCount,
      'user': user.toJson(),
    };
  }
}
