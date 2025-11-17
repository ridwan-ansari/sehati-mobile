class NutritionCreateRequest {
  final double heightCm;
  final double weightKg;

  NutritionCreateRequest({
    required this.heightCm,
    required this.weightKg,
  });

  Map<String, dynamic> toJson() {
    return {
      "height_cm": heightCm,
      "weight_kg": weightKg,
    };
  }
}
