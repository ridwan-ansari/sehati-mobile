enum FoodType {
  breakfast,
  morningSnack,
  lunch,
  afternoonSnack,
  dinner,
}

extension FoodTypeExtension on FoodType {
  String get label {
    switch (this) {
      case FoodType.breakfast:
        return "breakfast";

      case FoodType.morningSnack:
        return "morning_snack";

      case FoodType.lunch:
        return "lunch";

      case FoodType.afternoonSnack:
        return "afternoon_snack";

      case FoodType.dinner:
        return "dinner";
    }
  }
}
