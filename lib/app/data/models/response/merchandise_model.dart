class MerchandiseModel {
  final String id;
  final String name;
  final String description;
  final int pricePoints;
  final bool active;
  final String imageUrl;
  final int stock;

  final bool? isClaimed;
  final String? claimStatus;

  MerchandiseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePoints,
    required this.active,
    required this.imageUrl,
    required this.stock,
    this.isClaimed,
    this.claimStatus,
  });

  factory MerchandiseModel.fromJson(Map<String, dynamic> json) {
    return MerchandiseModel(
      id: json['id']?.toString() ?? "",
      name: json['name']?.toString() ?? "Unknown",
      description: json['description']?.toString() ?? "",
      pricePoints: json['price_points'] is int ? json['price_points'] : (int.tryParse(json['price_points']?.toString() ?? "0") ?? 0),
      active: json['active'] == true || json['active'] == 1,
      imageUrl: json['image_url']?.toString() ?? "",
      stock: json['stock'] is int ? json['stock'] : (int.tryParse(json['stock']?.toString() ?? "0") ?? 0),
      isClaimed: json['is_claimed'],
      claimStatus: json['claim'] != null && json['claim'] is Map ? json['claim']['status']?.toString() : null,
    );
  }
}
