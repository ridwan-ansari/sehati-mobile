enum FoodType {
  breakfast,
  lunch,
  dinner,
  snack,
}

extension FoodTypeExtension on FoodType {
  String get label {
    switch (this) {
      case FoodType.breakfast:
        return "Breakfast";
      case FoodType.lunch:
        return "Lunch";
      case FoodType.dinner:
        return "Dinner";
      case FoodType.snack:
        return "Snack";
    }
  }
}
