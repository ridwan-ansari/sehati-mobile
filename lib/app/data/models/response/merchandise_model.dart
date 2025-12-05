class MerchandiseModel {
  final String id;
  final String name;
  final String description;
  final int pricePoints;
  final bool active;
  final String imageUrl;
  final int stock;

  MerchandiseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePoints,
    required this.active,
    required this.imageUrl,
    required this.stock,
  });

  factory MerchandiseModel.fromJson(Map<String, dynamic> json) {
    return MerchandiseModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pricePoints: json['price_points'],
      active: json['active'],
      imageUrl: json['image_url'],
      stock: json['stock'],
    );
  }
}
