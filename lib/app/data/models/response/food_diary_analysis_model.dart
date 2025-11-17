class FoodDiaryAnalysis {
  final String userId;
  final int energyRequirement;
  final String id;
  final int totalCalories;
  final String activity;
  final String? updatedAt;
  final String? deletedAt;
  final int desiredEnergyRequirement;
  final int rewardPoints;
  final String createdAt;

  FoodDiaryAnalysis({
    required this.userId,
    required this.energyRequirement,
    required this.id,
    required this.totalCalories,
    required this.activity,
    required this.updatedAt,
    required this.deletedAt,
    required this.desiredEnergyRequirement,
    required this.rewardPoints,
    required this.createdAt,
  });

  factory FoodDiaryAnalysis.fromJson(Map<String, dynamic> json) {
    return FoodDiaryAnalysis(
      userId: json['user_id'],
      energyRequirement: json['energy_requirement'],
      id: json['id'],
      totalCalories: json['total_calories'],
      activity: json['activity'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      desiredEnergyRequirement: json['desired_energy_requirement'],
      rewardPoints: json['reward_points'],
      createdAt: json['created_at'],
    );
  }
}
