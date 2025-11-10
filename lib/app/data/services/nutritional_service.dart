import 'dart:math';

class NutritionalService {
  /// Hitung BMI (Body Mass Index)
  static double calculateBMI(double weight, double heightCm) {
    final heightM = heightCm / 100;
    return double.parse((weight / pow(heightM, 2)).toStringAsFixed(1));
  }

  /// Tentukan status gizi berdasarkan BMI
  static String getNutritionalStatus(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  /// Hitung berat badan ideal (rumus Broca)
  static double calculateIdealWeight(double heightCm) {
    final ideal = (heightCm - 100) - ((heightCm - 100) * 0.1);
    return double.parse(ideal.toStringAsFixed(1));
  }

  /// Hitung umur dari tanggal lahir
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
