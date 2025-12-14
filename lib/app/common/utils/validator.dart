class Validator {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email cannot be empty';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'invalid email format';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'password cannot be empty';
    if (value.length < 6) return 'Minimum 6 characters';
    return null;
  }

  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Field'} required';
    }
    return null;
  }
}
