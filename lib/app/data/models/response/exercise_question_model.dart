class ExerciseQuestionModel {
  final String id;
  final String question;
  final String category;
  final Map<String, String> options;
  final int order;
  final bool isActive;
  final String? example;
  final String questionType;
  final int rewardPoints;
  final String createdAt;
  final String? updatedAt;
  final String? deletedAt;

  // Tambahan untuk menyimpan jawaban sementara
  String? selectedOption;
  String? answerText;

  ExerciseQuestionModel({
    required this.id,
    required this.question,
    required this.category,
    required this.options,
    required this.order,
    required this.isActive,
    required this.example,
    required this.questionType,
    required this.rewardPoints,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.selectedOption,
    this.answerText,
  });

  factory ExerciseQuestionModel.fromJson(Map<String, dynamic> json) {
    Map<String, String> parsedOptions = {};
    if (json['options'] != null) {
      json['options'].forEach((key, value) {
        parsedOptions[key.toString()] = value.toString();
      });
    }

    return ExerciseQuestionModel(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      category: json['category'] ?? '',
      options: parsedOptions,
      order: json['order'] ?? 0,
      isActive: json['is_active'] ?? false,
      example: json['example'],
      questionType: json['question_type'] ?? '',
      rewardPoints: json['reward_points'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'category': category,
      'options': options,
      'order': order,
      'is_active': isActive,
      'example': example,
      'question_type': questionType,
      'reward_points': rewardPoints,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  Map<String, dynamic> toAnswerJson() {
    return {
      "question_id": id,
      "selected_option": selectedOption,
      "answer_text": answerText,
    };
  }
}
