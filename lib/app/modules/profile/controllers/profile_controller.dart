// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:sehati/app/data/models/response/profile_response_model.dart';
import 'package:sehati/app/data/services/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();
  final Rx<ProfileData?> dataProfile = Rx<ProfileData?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final profile = await _profileService.getProfile();
      if (profile != null) {
        dataProfile.value = profile;
        print("✅ Profil berhasil dimuat: ${profile.fullname}");
      } else {
        print("⚠️ Profil tidak ditemukan");
      }
    } catch (e) {
      print("❌ Gagal memuat profil: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// UPLOAD FOTO PROFIL
  Future<bool> uploadPhoto(String filePath) async {
    try {
      final result = await _profileService.uploadProfilePicture(filePath);
      if (result != null) {
        print("✅ Foto profil berhasil diupdate!");
        await loadProfile();
        return true;
      } else {
        print("⚠️ Gagal mengunggah foto profil");
        return false;
      }
    } catch (e) {
      print("❌ Upload error: $e");
      return false;
    }
  }
}
