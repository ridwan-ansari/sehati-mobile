import 'package:get/get.dart';
import 'package:sehati/app/data/services/language_service.dart';

class AppStrings {
  /// Selalu baca dari service - reactive saat diakses dalam Obx
  static LanguageService get _service => Get.find<LanguageService>();
  static String get _locale => _service.currentLanguage.value;
  static bool get isEnglish => _locale == "en";

  // ============= AUTH STRINGS =============

  // Auth messages
  static const String authKeyRegistering = "auth_registering";
  static const String authKeyLoggingIn = "auth_logging_in";
  static const String authKeyVerifyingOtp = "auth_verifying_otp";
  static const String authKeyRegisterSuccess = "auth_register_success";
  static const String authKeyLoginSuccess = "auth_login_success";
  static const String authKeyOtpSuccess = "auth_otp_success";
  static const String authKeyOtpError = "auth_otp_error";
  static const String authKeyError = "auth_error";

  // Login
  static const String loginKeyTitle = "login_title";
  static const String loginKeyEmail = "login_email";
  static const String loginKeyPassword = "login_password";
  static const String loginKeyButton = "login_button";
  static const String loginKeyForgot = "login_forgot";
  static const String loginKeyNoAccount = "login_no_account";
  static const String loginKeySignUp = "login_sign_up";

  // Register
  static const String registerKeyTitle = "register_title";
  static const String registerKeyAlreadyHave = "register_already_have";
  static const String registerKeySignIn = "register_sign_in";
  static const String registerKeyName = "register_name";
  static const String registerKeyEmail = "register_email";
  static const String registerKeyPassword = "register_password";
  static const String registerKeyNext = "register_next";
  static const String registerKeyNameEmpty = "register_name_empty";

  // OTP
  static const String otpKeyTitle = "otp_title";
  static const String otpKeyMessage = "otp_message";
  static const String otpKeyVerify = "otp_verify";
  static const String otpKeyResend = "otp_resend";

  // Forgot Password
  static const String forgotKeyTitle = "forgot_title";
  static const String forgotKeyMessage = "forgot_message";
  static const String forgotKeyEmail = "forgot_email";
  static const String forgotKeyButton = "forgot_button";

  // Input Profile
  static const String profileKeyTitle = "profile_title";
  static const String profileKeyFullName = "profile_full_name";
  static const String profileKeyAge = "profile_age";
  static const String profileKeyGender = "profile_gender";
  static const String profileKeyHeight = "profile_height";
  static const String profileKeyWeight = "profile_weight";
  static const String profileKeyContinue = "profile_continue";
  static const String profileKeyNickName = "profile_nick_name";
  static const String profileKeyDateOfBirth = "profile_date_of_birth";
  static const String profileKeyPhone = "profile_phone";
  static const String profileKeyMale = "profile_male";
  static const String profileKeyFemale = "profile_female";
  static const String profileKeyCompleteSignUp = "profile_complete_sign_up";

  // Nutritional Status
  static const String nutritionKeyTitle = "nutrition_title";
  static const String nutritionKeyPageTitle = "nutrition_page_title";
  static const String nutritionKeyWeight = "nutrition_weight";
  static const String nutritionKeyHeight = "nutrition_height";
  static const String nutritionKeyCalculate = "nutrition_calculate";
  static const String nutritionKeyBmi = "nutrition_bmi";
  static const String nutritionKeyNutritionalStatus = "nutrition_status_label";
  static const String nutritionKeyIdealWeight = "nutrition_ideal_weight";
  static const String nutritionKeyFinish = "nutrition_finish";
  static const String nutritionKeyCalories = "nutrition_calories";
  static const String nutritionKeyProtein = "nutrition_protein";
  static const String nutritionKeyCarbs = "nutrition_carbs";
  static const String nutritionKeyFat = "nutrition_fat";
  static const String nutritionKeyNext = "nutrition_next";
  static const String nutritionKeyInvalidInput = "nutrition_invalid_input";

  // Reminder
  static const String reminderKeyTitle = "reminder_title";
  static const String reminderKeyName = "reminder_name";
  static const String reminderKeyTime = "reminder_time";
  static const String reminderKeyFrequency = "reminder_frequency";
  static const String reminderKeyAdd = "reminder_add";
  static const String reminderKeySave = "reminder_save";

  // ============= MENU / NAVIGATION STRINGS =============

  // Bottom nav
  static const String menuKeyHome = "menu_home";
  static const String menuKeyCommunity = "menu_community";
  static const String menuKeySchedule = "menu_schedule";
  static const String menuKeyProfile = "menu_profile";

  // Section headers
  static const String menuKeyFeatures = "menu_features";
  static const String menuKeySeeAll = "menu_see_all";
  static const String menuKeyGames = "menu_games";
  static const String menuKeyAllGames = "menu_all_games";
  static const String menuKeyAllFeatures = "menu_all_features";

  // Feature names
  static const String menuKeyMonitoring = "menu_monitoring";
  static const String menuKeyAppointment = "menu_appointment";
  static const String menuKeyEdutainment = "menu_edutainment";
  static const String menuKeyGame = "menu_game";
  static const String menuKeyJournal = "menu_journal";
  static const String menuKeyChat = "menu_chat";
  static const String menuKeyRecipes = "menu_recipes";
  static const String menuKeyReminder = "menu_reminder";
  static const String menuKeySleep = "menu_sleep";
  static const String menuKeyMerchandise = "menu_merchandise";
  static const String menuKeyDailyJournal = "menu_daily_journal";

  // Categories
  static const String menuCatHealth = "menu_cat_health";
  static const String menuCatLearn = "menu_cat_learn";
  static const String menuCatNutrition = "menu_cat_nutrition";
  static const String menuCatSocial = "menu_cat_social";
  static const String menuCatRewards = "menu_cat_rewards";

  // Stats
  static const String menuKeyPoints = "menu_points";
  static const String menuKeyBalance = "menu_balance";
  static const String menuKeyRank = "menu_rank";

  // Search / empty states
  static const String menuKeySearchMenu = "menu_search_menu";
  static const String menuKeySearchFeatures = "menu_search_features";
  static const String menuKeyNoMenuFound = "menu_no_menu_found";
  static const String menuKeyNoFeatureFound = "menu_no_feature_found";
  static const String menuKeyNoGamesYet = "menu_no_games_yet";

  // Journal
  static const String menuKeyFoodDiary = "menu_food_diary";
  static const String menuKeyFoodHabit = "menu_food_habit";
  static const String menuKeyExerciseHabit = "menu_exercise_habit";
  static const String menuKeyStartJournalling = "menu_start_journalling";
  static const String menuKeyReward = "menu_reward";
  static const String menuKeyWriteJournal = "menu_write_journal";

  // ============= COMMON STRINGS =============
  static const String commonKeyEmail = "common_email";
  static const String commonKeyPassword = "common_password";
  static const String commonKeyName = "common_name";
  static const String commonKeyCancel = "common_cancel";
  static const String commonKeySave = "common_save";
  static const String commonKeyDelete = "common_delete";
  static const String commonKeyEdit = "common_edit";
  static const String commonKeyAdd = "common_add";
  static const String commonKeyClose = "common_close";
  static const String commonKeySubmit = "common_submit";
  static const String commonKeyNext = "common_next";
  static const String commonKeyBack = "common_back";

  // ============= VALIDATION STRINGS =============
  static const String validationKeyEmailRequired = "validation_email_required";
  static const String validationKeyEmailInvalid = "validation_email_invalid";
  static const String validationKeyPasswordRequired = "validation_password_required";
  static const String validationKeyPasswordWeak = "validation_password_weak";
  static const String validationKeyNameRequired = "validation_name_required";
  static const String validationKeyFieldRequired = "validation_field_required";
  static const String validationKeyNicknameRequired = "validation_nickname_required";
  static const String validationKeyNicknameTooLong = "validation_nickname_too_long";
  static const String validationKeyPhoneRequired = "validation_phone_required";
  static const String validationKeyPhoneInvalid = "validation_phone_invalid";

  // ============= GET LOCALIZED STRING =============
  static String get(String key) => _strings[_locale]?[key] ?? key;

  static String getOr(String enText, String idText) => isEnglish ? enText : idText;

  // ============= STRINGS MAP =============
  static const Map<String, Map<String, String>> _strings = {
    "en": {
      // Auth messages
      "auth_registering": "Creating your account...",
      "auth_logging_in": "Logging in...",
      "auth_verifying_otp": "Verifying OTP...",
      "auth_register_success": "Account created! Please verify your email.",
      "auth_login_success": "Welcome back!",
      "auth_otp_success": "Email verified! You can now log in.",
      "auth_otp_error": "OTP verification failed. Please try again.",
      "auth_error": "An error occurred. Please try again.",

      // Auth - Login
      "login_title": "Login",
      "login_email": "Email",
      "login_password": "Password",
      "login_button": "Login",
      "login_forgot": "Forgot password?",
      "login_no_account": "Don't have an account? ",
      "login_sign_up": "Sign Up",

      // Auth - Register
      "register_title": "Sign Up",
      "register_already_have": "Already registered? ",
      "register_sign_in": "Sign in",
      "register_name": "Name",
      "register_email": "Email",
      "register_password": "Password",
      "register_next": "Next",
      "register_name_empty": "Name cannot be empty",

      // OTP
      "otp_title": "Verify OTP",
      "otp_message": "Enter the 6-digit code sent to your email",
      "otp_verify": "Verify",
      "otp_resend": "Resend OTP",

      // Forgot Password
      "forgot_title": "Forgot Password",
      "forgot_message": "Enter your email to reset password",
      "forgot_email": "Email",
      "forgot_button": "Send Reset Link",

      // Input Profile
      "profile_title": "Complete Your Profile",
      "profile_full_name": "Full Name",
      "profile_age": "Age",
      "profile_gender": "Gender",
      "profile_height": "Height (cm)",
      "profile_weight": "Weight (kg)",
      "profile_continue": "Continue",
      "profile_nick_name": "Nick Name",
      "profile_date_of_birth": "Date of Birth",
      "profile_phone": "Phone Number",
      "profile_male": "Male",
      "profile_female": "Female",
      "profile_complete_sign_up": "Complete your Sign Up",

      // Nutritional Status
      "nutrition_title": "Set Nutritional Goals",
      "nutrition_page_title": "Nutritional Status",
      "nutrition_weight": "Bodyweight (kg)",
      "nutrition_height": "Bodyheight (cm)",
      "nutrition_calculate": "Calculate",
      "nutrition_bmi": "BMI",
      "nutrition_status_label": "Nutritional Status",
      "nutrition_ideal_weight": "Ideal Bodyweight",
      "nutrition_finish": "Finish",
      "nutrition_invalid_input": "Please enter valid weight & height",
      "nutrition_calories": "Daily Calories",
      "nutrition_protein": "Protein (g)",
      "nutrition_carbs": "Carbs (g)",
      "nutrition_fat": "Fat (g)",
      "nutrition_next": "Next",

      // Reminder
      "reminder_title": "Add Reminder",
      "reminder_name": "Reminder Name",
      "reminder_time": "Time",
      "reminder_frequency": "Frequency",
      "reminder_add": "Add",
      "reminder_save": "Save",

      // Menu / Navigation
      "menu_home": "Home",
      "menu_community": "Community",
      "menu_schedule": "Schedule",
      "menu_profile": "Profile",
      "menu_features": "Features",
      "menu_see_all": "See All",
      "menu_games": "Games",
      "menu_all_games": "All Games",
      "menu_all_features": "All Features",
      "menu_monitoring": "Monitoring",
      "menu_appointment": "Appointment",
      "menu_edutainment": "Edutainment",
      "menu_game": "Game",
      "menu_journal": "Journal",
      "menu_chat": "Chat",
      "menu_recipes": "Recipes",
      "menu_reminder": "Reminder",
      "menu_sleep": "Sleep",
      "menu_merchandise": "Merchandise",
      "menu_daily_journal": "Daily Journal",
      "menu_cat_health": "Health",
      "menu_cat_learn": "Learn",
      "menu_cat_nutrition": "Nutrition",
      "menu_cat_social": "Social",
      "menu_cat_rewards": "Rewards",
      "menu_points": "Points",
      "menu_balance": "Balance",
      "menu_rank": "Rank",
      "menu_search_menu": "Search menu...",
      "menu_search_features": "Search features...",
      "menu_no_menu_found": "No menu found",
      "menu_no_feature_found": "No features found",
      "menu_no_games_yet": "No games available yet",
      "menu_food_diary": "Food Diary",
      "menu_food_habit": "Food Habit",
      "menu_exercise_habit": "Exercise Habit",
      "menu_start_journalling": "Start Journalling",
      "menu_reward": "Reward",
      "menu_write_journal": "Write Down Your Daily Journal, Here!",

      // Common
      "common_email": "Email",
      "common_password": "Password",
      "common_name": "Name",
      "common_cancel": "Cancel",
      "common_save": "Save",
      "common_delete": "Delete",
      "common_edit": "Edit",
      "common_add": "Add",
      "common_close": "Close",
      "common_submit": "Submit",
      "common_next": "Next",
      "common_back": "Back",

      // Validation
      "validation_email_required": "Email is required",
      "validation_email_invalid": "Email is invalid",
      "validation_password_required": "Password is required",
      "validation_password_weak": "Password must be at least 8 characters with letters and numbers",
      "validation_name_required": "Name is required",
      "validation_field_required": "This field is required",
      "validation_nickname_required": "Nickname cannot be empty",
      "validation_nickname_too_long": "Nickname too long",
      "validation_phone_required": "Phone number cannot be empty",
      "validation_phone_invalid": "Invalid phone number",
    },
    "id": {
      // Auth messages
      "auth_registering": "Membuat akun Anda...",
      "auth_logging_in": "Sedang masuk...",
      "auth_verifying_otp": "Memverifikasi OTP...",
      "auth_register_success": "Akun dibuat! Silakan verifikasi email Anda.",
      "auth_login_success": "Selamat datang kembali!",
      "auth_otp_success": "Email terverifikasi! Silakan login.",
      "auth_otp_error": "Verifikasi OTP gagal. Silakan coba lagi.",
      "auth_error": "Terjadi kesalahan. Silakan coba lagi.",

      // Auth - Login
      "login_title": "Masuk",
      "login_email": "Email",
      "login_password": "Kata Sandi",
      "login_button": "Masuk",
      "login_forgot": "Lupa kata sandi?",
      "login_no_account": "Belum punya akun? ",
      "login_sign_up": "Daftar",

      // Auth - Register
      "register_title": "Daftar",
      "register_already_have": "Sudah terdaftar? ",
      "register_sign_in": "Masuk",
      "register_name": "Nama",
      "register_email": "Email",
      "register_password": "Kata Sandi",
      "register_next": "Lanjut",
      "register_name_empty": "Nama tidak boleh kosong",

      // OTP
      "otp_title": "Verifikasi OTP",
      "otp_message": "Masukkan kode 6 digit yang dikirim ke email Anda",
      "otp_verify": "Verifikasi",
      "otp_resend": "Kirim Ulang OTP",

      // Forgot Password
      "forgot_title": "Lupa Kata Sandi",
      "forgot_message": "Masukkan email Anda untuk reset kata sandi",
      "forgot_email": "Email",
      "forgot_button": "Kirim Link Reset",

      // Input Profile
      "profile_title": "Lengkapi Profil Anda",
      "profile_full_name": "Nama Lengkap",
      "profile_age": "Usia",
      "profile_gender": "Jenis Kelamin",
      "profile_height": "Tinggi Badan (cm)",
      "profile_weight": "Berat Badan (kg)",
      "profile_continue": "Lanjut",
      "profile_nick_name": "Nama Panggilan",
      "profile_date_of_birth": "Tanggal Lahir",
      "profile_phone": "Nomor Telepon",
      "profile_male": "Laki-laki",
      "profile_female": "Perempuan",
      "profile_complete_sign_up": "Lengkapi Pendaftaran Anda",

      // Nutritional Status
      "nutrition_title": "Atur Target Nutrisi",
      "nutrition_page_title": "Status Gizi",
      "nutrition_weight": "Berat Badan (kg)",
      "nutrition_height": "Tinggi Badan (cm)",
      "nutrition_calculate": "Hitung",
      "nutrition_bmi": "BMI",
      "nutrition_status_label": "Status Gizi",
      "nutrition_ideal_weight": "Berat Badan Ideal",
      "nutrition_finish": "Selesai",
      "nutrition_invalid_input": "Masukkan berat dan tinggi badan yang valid",
      "nutrition_calories": "Kalori Harian",
      "nutrition_protein": "Protein (g)",
      "nutrition_carbs": "Karbohidrat (g)",
      "nutrition_fat": "Lemak (g)",
      "nutrition_next": "Lanjut",

      // Reminder
      "reminder_title": "Tambah Pengingat",
      "reminder_name": "Nama Pengingat",
      "reminder_time": "Waktu",
      "reminder_frequency": "Frekuensi",
      "reminder_add": "Tambah",
      "reminder_save": "Simpan",

      // Menu / Navigation
      "menu_home": "Beranda",
      "menu_community": "Komunitas",
      "menu_schedule": "Jadwal",
      "menu_profile": "Profil",
      "menu_features": "Fitur",
      "menu_see_all": "Lihat Semua",
      "menu_games": "Permainan",
      "menu_all_games": "Semua Permainan",
      "menu_all_features": "Semua Fitur",
      "menu_monitoring": "Monitoring",
      "menu_appointment": "Konsultasi",
      "menu_edutainment": "Edutainment",
      "menu_game": "Game",
      "menu_journal": "Jurnal",
      "menu_chat": "Obrolan",
      "menu_recipes": "Resep",
      "menu_reminder": "Pengingat",
      "menu_sleep": "Tidur",
      "menu_merchandise": "Merchandise",
      "menu_daily_journal": "Jurnal Harian",
      "menu_cat_health": "Kesehatan",
      "menu_cat_learn": "Belajar",
      "menu_cat_nutrition": "Nutrisi",
      "menu_cat_social": "Sosial",
      "menu_cat_rewards": "Hadiah",
      "menu_points": "Poin",
      "menu_balance": "Saldo",
      "menu_rank": "Peringkat",
      "menu_search_menu": "Cari menu...",
      "menu_search_features": "Cari fitur...",
      "menu_no_menu_found": "Tidak ada menu ditemukan",
      "menu_no_feature_found": "Tidak ada fitur ditemukan",
      "menu_no_games_yet": "Belum ada permainan tersedia",
      "menu_food_diary": "Catatan Makanan",
      "menu_food_habit": "Kebiasaan Makan",
      "menu_exercise_habit": "Kebiasaan Olahraga",
      "menu_start_journalling": "Mulai Membuat Jurnal",
      "menu_reward": "Hadiah",
      "menu_write_journal": "Tulis Jurnal Harianmu di Sini!",

      // Common
      "common_email": "Email",
      "common_password": "Kata Sandi",
      "common_name": "Nama",
      "common_cancel": "Batal",
      "common_save": "Simpan",
      "common_delete": "Hapus",
      "common_edit": "Edit",
      "common_add": "Tambah",
      "common_close": "Tutup",
      "common_submit": "Kirim",
      "common_next": "Lanjut",
      "common_back": "Kembali",

      // Validation
      "validation_email_required": "Email wajib diisi",
      "validation_email_invalid": "Email tidak valid",
      "validation_password_required": "Kata sandi wajib diisi",
      "validation_password_weak": "Kata sandi harus minimal 8 karakter dengan huruf dan angka",
      "validation_name_required": "Nama wajib diisi",
      "validation_field_required": "Kolom ini wajib diisi",
      "validation_nickname_required": "Nama panggilan tidak boleh kosong",
      "validation_nickname_too_long": "Nama panggilan terlalu panjang",
      "validation_phone_required": "Nomor telepon tidak boleh kosong",
      "validation_phone_invalid": "Nomor telepon tidak valid",
    }
  };
}
