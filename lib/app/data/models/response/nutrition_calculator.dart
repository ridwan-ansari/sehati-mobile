class NutritionCalculator {
  final double? bmi;
  final double? zscore;
  final String? status;
  final double? ibw;
  final double? eer;

  NutritionCalculator({
    this.bmi,
    this.zscore,
    this.status,
    this.ibw,
    this.eer,
  });

  factory NutritionCalculator.fromJson(Map<String, dynamic> json) {
    return NutritionCalculator(
      bmi: (json['bmi'] as num?)?.toDouble(),
      zscore: (json['zscore'] as num?)?.toDouble(),
      status: json['status']?.toString(),
      ibw: (json['ibw'] as num?)?.toDouble(),
      eer: (json['eer'] as num?)?.toDouble(),
    );
  }
}
