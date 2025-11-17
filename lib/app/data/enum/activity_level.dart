enum ActivityLevel {
  sedentary,
  low_active,
  active,
  very_active,
}

extension ActivityLabel on ActivityLevel {
  String get label {
    switch (this) {
      case ActivityLevel.sedentary:
        return "Sedentary";
      case ActivityLevel.low_active:
        return "Low Active";
      case ActivityLevel.active:
        return "Active";
      case ActivityLevel.very_active:
        return "Very Active";
    }
  }
}
