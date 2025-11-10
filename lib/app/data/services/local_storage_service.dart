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
}
