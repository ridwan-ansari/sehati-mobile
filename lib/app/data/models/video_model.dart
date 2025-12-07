class VideoModel {
  final String id;
  final String title;
  final String youtubeUrl;
  final int rewardPoints;
  final int? durationSeconds;
  final String description;
  final String? thumbnail;
  final String? category;
  final bool isActive;
  final String createdAt;

  VideoModel({
    required this.id,
    required this.title,
    required this.youtubeUrl,
    required this.rewardPoints,
    this.durationSeconds,
    required this.description,
    this.thumbnail,
    this.category,
    required this.isActive,
    required this.createdAt,
  });
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      youtubeUrl: json['youtube_url'] ?? '',
      rewardPoints: json['reward_points'] == null
          ? 0
          : int.tryParse(json['reward_points'].toString()) ?? 0,
      durationSeconds: json['duration_seconds'] == null
          ? null
          : int.tryParse(json['duration_seconds'].toString()),
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'],
      category: json['category'],
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}
