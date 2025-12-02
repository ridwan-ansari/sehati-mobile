class RecipeModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final String fileUrl;

  RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.fileUrl,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      imageUrl: json['image_url'],
      fileUrl: json['file_url'],
    );
  }
}
