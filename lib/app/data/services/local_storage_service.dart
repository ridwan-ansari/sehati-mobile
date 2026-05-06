import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  static final _box = GetStorage();

  // Simpan access token
  static Future<void> setAccessToken(String token) async {
    await _box.write('access_token', token);
  }

  static String? getAccessToken() {
    return _box.read('access_token');
  }

  // Simpan refresh token
  static Future<void> setRefreshToken(String token) async {
    await _box.write('refresh_token', token);
  }

  static String? getRefreshToken() {
    return _box.read('refresh_token');
  }


  static Future<void> clearTokens() async {
    await _box.remove('access_token');
    await _box.remove('refresh_token');
  }

  static Future<void> init() async {
    await GetStorage.init();
  }

  // --- Habit Submission Tracking ---
  static Future<void> setLastHabitSubmit(String date) async {
    await _box.write('last_habit_submit', date);
  }

  static String? getLastHabitSubmit() {
    return _box.read('last_habit_submit');
  }

  static Future<void> setLastExerciseSubmit(String date) async {
    await _box.write('last_exercise_submit', date);
  }

  static String? getLastExerciseSubmit() {
    return _box.read('last_exercise_submit');
  }
}
