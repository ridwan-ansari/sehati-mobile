import 'package:sehati/app/common/localization/app_strings.dart';

class Validator {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return AppStrings.get(AppStrings.validationKeyEmailRequired);
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
    if (!emailRegex.hasMatch(value)) return AppStrings.get(AppStrings.validationKeyEmailInvalid);
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return AppStrings.get(AppStrings.validationKeyPasswordRequired);
    final passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return AppStrings.get(AppStrings.validationKeyPasswordWeak);
    }
    return null;
  }

  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return AppStrings.get(AppStrings.validationKeyFieldRequired);
    }
    return null;
  }
}
