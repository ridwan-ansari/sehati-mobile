import 'package:sehati/app/common/localization/app_strings.dart';

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
        return AppStrings.get(AppStrings.foodTypeBreakfast);

      case FoodType.morningSnack:
        return AppStrings.get(AppStrings.foodTypeMorningSnack);

      case FoodType.lunch:
        return AppStrings.get(AppStrings.foodTypeLunch);

      case FoodType.afternoonSnack:
        return AppStrings.get(AppStrings.foodTypeAfternoonSnack);

      case FoodType.dinner:
        return AppStrings.get(AppStrings.foodTypeDinner);
    }
  }
}
