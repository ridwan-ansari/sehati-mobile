class GameModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int pricePoints;
  final bool isClaim;

  GameModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.pricePoints,
    required this.isClaim,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      pricePoints: json['price_points'] ?? 0,
      isClaim: json['is_claim'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'price_points': pricePoints,
      'is_claim': isClaim,
    };
  }
}
