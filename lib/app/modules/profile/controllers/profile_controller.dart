
import 'package:get/get.dart';
import 'package:sehati/app/data/models/response/profile_response_model.dart';
import 'package:sehati/app/data/services/profile_service.dart';
import 'package:sehati/app/data/services/language_service.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();
  final Rx<ProfileData?> dataProfile = Rx<ProfileData?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void changeLanguage(String code) async {
    final langService = Get.find<LanguageService>();
    await langService.setLanguage(code);
    Get.back(); // Close dialog/bottomsheet
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final profile = await _profileService.getProfile();
      if (profile != null) {
        dataProfile.value = profile;
        AppLogger.log("✅ Profil berhasil dimuat: ${profile.fullname}");
      } else {
        AppLogger.log("⚠️ Profil tidak ditemukan");
      }
    } catch (e) {
      AppLogger.log("❌ Gagal memuat profil: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// UPLOAD FOTO PROFIL
  Future<bool> uploadPhoto(String filePath) async {
    try {
      final result = await _profileService.uploadProfilePicture(filePath);
      if (result != null) {
        AppLogger.log("✅ Foto profil berhasil diupdate!");
        await loadProfile();
        return true;
      } else {
        AppLogger.log("⚠️ Gagal mengunggah foto profil");
        return false;
      }
    } catch (e) {
      AppLogger.log("❌ Upload error: $e");
      return false;
    }
  }
}
