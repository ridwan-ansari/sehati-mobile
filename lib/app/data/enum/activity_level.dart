// ignore_for_file: constant_identifier_names

import 'package:sehati/app/common/localization/app_strings.dart';

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
        return AppStrings.get(AppStrings.activitySedentary);
      case ActivityLevel.low_active:
        return AppStrings.get(AppStrings.activityLowActive);
      case ActivityLevel.active:
        return AppStrings.get(AppStrings.activityActive);
      case ActivityLevel.very_active:
        return AppStrings.get(AppStrings.activityVeryActive);
    }
  }
}
