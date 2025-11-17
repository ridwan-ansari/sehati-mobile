class FoodModel {
  final String id;
  final String name;
  final int calories;
  final String description;
  final String category;
  final String unit;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  FoodModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.description,
    required this.category,
    required this.unit,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      calories: json['calories'] ?? 0,
      description: json['description'] ?? "",
      category: json['category'] ?? "",
      unit: json['unit'] ?? "",
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "calories": calories,
      "description": description,
      "category": category,
      "unit": unit,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "deleted_at": deletedAt?.toIso8601String(),
    };
  }
}
