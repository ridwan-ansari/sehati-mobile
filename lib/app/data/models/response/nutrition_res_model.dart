// nutrition_response.dart
class NutritionResponse {
  final int statusCode;
  final String message;
  final List<NutritionData> data;

  NutritionResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory NutritionResponse.fromJson(Map<String, dynamic> json) {
    return NutritionResponse(
      statusCode: json['status_code'],
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => NutritionData.fromJson(e))
          .toList(),
    );
  }
}

class NutritionData {
  final int id;
  final double bmi;
  final double weightKg;
  final double heightCm;
  final double idealWeightKg;
  final String status;
  final String userId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  NutritionData({
    required this.id,
    required this.bmi,
    required this.weightKg,
    required this.heightCm,
    required this.idealWeightKg,
    required this.status,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

 factory NutritionData.fromJson(Map<String, dynamic> json) {
  return NutritionData(
    id: json['id'] ?? 0,
    bmi: json['bmi'] != null ? double.tryParse(json['bmi'].toString()) ?? 0.0 : 0.0,
    weightKg: json['weight_kg'] != null ? double.tryParse(json['weight_kg'].toString()) ?? 0.0 : 0.0,
    heightCm: json['height_cm'] != null ? double.tryParse(json['height_cm'].toString()) ?? 0.0 : 0.0,
    idealWeightKg: json['ideal_weight_kg'] != null ? double.tryParse(json['ideal_weight_kg'].toString()) ?? 0.0 : 0.0,
    status: json['status'] ?? '',
    userId: json['user_id'] ?? '',
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: (json['updated_at'] != null)
        ? DateTime.parse(json['updated_at'])
        : null,
    deletedAt: json['deleted_at'] != null
        ? DateTime.parse(json['deleted_at'])
        : null,
  );
}

}
