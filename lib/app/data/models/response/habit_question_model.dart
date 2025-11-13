class HabitQuestionModel {
  final String id;
  final String category;
  final String question;
  final int rewardPoints;
  final bool isActive;

  // Optional
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? example;

  // User answer
  String? selectedOption;
  String? answerText;

  HabitQuestionModel({
    required this.id,
    required this.category,
    required this.question,
    required this.rewardPoints,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.example,
    this.selectedOption,
    this.answerText,
  });

  factory HabitQuestionModel.fromJson(Map<String, dynamic> json) {
    return HabitQuestionModel(
      id: json['id'],
      category: json['category'],
      question: json['question'],
      rewardPoints: json['reward_points'] ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      example: json['example'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'question': question,
      'reward_points': rewardPoints,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'example': example,
      'selected_option': selectedOption,
      'answer_text': answerText,
    };
  }
}
