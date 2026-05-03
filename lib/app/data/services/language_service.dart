import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends GetxService {
  static const String _languageKey = 'app_language';

  final currentLanguage = 'id'.obs;
  late SharedPreferences _prefs;

  LanguageService._();

  /// Factory yang di-await sepenuhnya sebelum app berlanjut
  static Future<LanguageService> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final service = LanguageService._();
    service._prefs = prefs;
    service.currentLanguage.value = prefs.getString(_languageKey) ?? 'id';
    return service;
  }

  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(_languageKey, languageCode);
    currentLanguage.value = languageCode;
  }

  bool isEnglish() => currentLanguage.value == 'en';
}
