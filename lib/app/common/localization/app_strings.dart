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
  static const String authKeyResendingOtp = "auth_resending_otp";
  static const String authKeySendingReset = "auth_sending_reset";
  static const String authKeyResettingPassword = "auth_resetting_password";
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
  static const String forgotKeyOtp = "forgot_otp";
  static const String forgotKeyNewPassword = "forgot_new_password";
  static const String forgotKeyConfirmPassword = "forgot_confirm_password";

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
  static const String nutritionKeySelectDate = "nutrition_select_date";
  static const String nutritionKeyWelcome = "nutrition_welcome";
  static const String nutritionKeyBodyweightMonitoring = "nutrition_bodyweight_monitoring";
  static const String nutritionKeyDateMeasurement = "nutrition_date_measurement";
  static const String nutritionKeyNoData = "nutrition_no_data";
  static const String nutritionKeyWeeklyReminder = "nutrition_weekly_reminder";

  // Edutainment
  static const String eduKeyWelcome = "edu_welcome";
  static const String eduKeyNoVideos = "edu_no_videos";
  static const String eduKeyDuration = "edu_duration";
  static const String eduKeyMinutes = "edu_minutes";

  // Sleep
  static const String sleepKeyWelcome = "sleep_welcome";
  static const String sleepKeyTarget = "sleep_target";
  static const String sleepKeyActual = "sleep_actual";
  static const String sleepKeyHours = "sleep_hours";
  static const String sleepKeyNoData = "sleep_no_data";
  static const String sleepKeyNoRecords = "sleep_no_records";
  static const String sleepKeySleepingDuration = "sleep_sleeping_duration";
  static const String sleepKeyTargetLabel = "sleep_target_label";

  static const String commonKeySuccess = "common_success";
  static const String commonKeyError = "common_error";
  static const String commonKeyTokenNotFound = "common_token_not_found";
  static const String commonKeyExitPressAgain = "common_exit_press_again";
  static const String commonKeyUnknown = "common_unknown";
  static const String commonKeyNotSet = "common_not_set";
  static const String commonKeyNoDataAvailable = "common_no_data_available";
  static const String commonKeyInvalidInput = "common_invalid_input";
  static const String commonKeyClaimingPoint = "common_claiming_point";
  static const String commonKeyProcessing = "common_processing";
  static const String commonKeyLoading = "common_loading";
  static const String commonKeyAutofill = "common_autofill";
  static const String commonKeyPlay = "common_play";
  static const String commonKeyClaim = "common_claim";

  // SNACKBAR MESSAGES
  static const String snackKeyOtpResent = "snack_otp_resent";
  static const String snackKeyPointClaimed = "snack_point_claimed";
  static const String snackKeyLoadFailed = "snack_load_failed";
  static const String snackKeyErrorLoading = "snack_error_loading";
  static const String appointmentKeyProfNotSelected = "appointment_prof_not_selected";
  static const String appointmentKeyDetailsIncomplete = "appointment_details_incomplete";

  // Reminder
  static const String reminderKeyNoReminders = "reminder_no_reminders";
  static const String reminderKeyAddReminder = "reminder_add_reminder";
  static const String reminderKeyAdd = "reminder_add";
  static const String reminderKeyName = "reminder_name";
  static const String reminderKeyTime = "reminder_time";
  static const String reminderKeyFrequency = "reminder_frequency";
  static const String reminderKeyEveryDay = "reminder_every_day";
  static const String reminderKeyDeleteConfirmTitle = "reminder_delete_confirm_title";
  static const String reminderKeyDeleteConfirmMessage = "reminder_delete_confirm_message";
  static const String reminderKeyTapToChange = "reminder_tap_to_change";
  static const String reminderKeyCreating = "reminder_creating";
  static const String reminderKeyUpdating = "reminder_updating";
  static const String reminderKeyDeleting = "reminder_deleting";

  // Days
  static const String dayKeyMonday = "day_monday";
  static const String dayKeyTuesday = "day_tuesday";
  static const String dayKeyWednesday = "day_wednesday";
  static const String dayKeyThursday = "day_thursday";
  static const String dayKeyFriday = "day_friday";
  static const String dayKeySaturday = "day_saturday";
  static const String dayKeySunday = "day_sunday";

  // Exercise
  static const String exerciseKeyQuestion = "exercise_question";
  static const String exerciseKeyOf = "exercise_of";
  static const String exerciseKeyNoQuestions = "exercise_no_questions";
  static const String exerciseKeyConfirmExit = "exercise_confirm_exit";
  static const String exerciseKeyExitMessage = "exercise_exit_message";
  static const String exerciseKeyDailyQuiz = "exercise_daily_quiz";
  static const String exerciseKeyUnknownType = "exercise_unknown_type";
  static const String exerciseKeyFinish = "exercise_finish";
  static const String exerciseKeyNext = "exercise_next";

  // Chat
  static const String chatKeyTypeMessage = "chat_type_message";
  static const String commonKeySearchFood = "common_search_food";

  // Reminder
  static const String commonKeyEnterTitle = "common_enter_title";
  static const String commonKeyPermissionRequired = "common_permission_required";
  static const String commonKeyPermissionMessage = "common_permission_message";
  static const String commonKeyOpenSettings = "common_open_settings";
  static const String commonKeyPointsLabel = "common_points_label";

  // Merchandise
  static const String merchKeyTitle = "merch_title";
  static const String merchKeyPoints = "merch_points";
  static const String merchKeyClaim = "merch_claim";
  static const String merchKeyNoMerch = "merch_no_merch";

  // Profile
  static const String profileKeyInfo = "profile_info";
  static const String profileKeySettings = "profile_settings";
  static const String profileKeyChangePhoto = "profile_change_photo";
  static const String profileKeySignOut = "profile_sign_out";
  static const String profileKeyLanguage = "profile_language";
  static const String profileKeySelectLanguage = "profile_select_language";
  static const String profileKeyNickname = "profile_nickname";
  static const String profileKeyGenderLabel = "profile_gender_label";
  static const String profileKeyChangePhotoTitle = "profile_change_photo_title";
  static const String profileKeySelectedPhoto = "profile_selected_photo";

  // Community
  static const String forumKeyTitle = "forum_title";
  static const String forumKeyTakePhoto = "forum_take_photo";
  static const String forumKeyPostContent = "forum_post_content";
  static const String forumKeyLike = "forum_like";
  static const String forumKeyComment = "forum_comment";
  static const String forumKeyShare = "forum_share";
  static const String forumKeyWriteComment = "forum_write_comment";
  static const String forumKeyPosts = "forum_posts";
  static const String forumKeyFollowers = "forum_followers";
  static const String forumKeyFollowing = "forum_following";
  static const String forumKeyNoPosts = "forum_no_posts";
  static const String forumKeyNoComments = "forum_no_comments";

  // ============= MENU / NAVIGATION STRINGS =============

  // Bottom nav
  static const String menuKeyHome = "menu_home";
  static const String menuKeyCommunity = "menu_community";
  static const String menuKeySchedule = "menu_schedule";
  static const String menuKeyProfile = "menu_profile";
  static const String menuKeyJournalTitle = "menu_journal_title";

  // Section headers
  static const String menuKeyFeatures = "menu_features";
  static const String menuKeySeeAll = "menu_see_all";
  static const String menuKeyGames = "menu_games";
  static const String menuKeyAllGames = "menu_all_games";
  static const String menuKeyAllFeatures = "menu_all_features";

  // Feature names
  static const String menuKeyMonitoring = "menu_monitoring";
  static const String menuKeyAppointment = "menu_appointment";
  static const String menuKeyChatCounselor = "menu_chat_counselor";
  static const String menuKeyBookNow = "menu_book_now";
  static const String menuKeyScheduleAppointment = "menu_schedule_appointment";
  static const String menuKeyChatWA = "menu_chat_wa";
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

  // Leaderboard
  static const String leaderboardKeyTitle = "leaderboard_title";
  static const String leaderboardKeyTopPlayers = "leaderboard_top_players";
  static const String leaderboardKeyYourPosition = "leaderboard_your_position";
  static const String leaderboardKeyOtherPlayers = "leaderboard_other_players";
  static const String leaderboardKeyNoData = "leaderboard_no_data";
  static const String leaderboardKeyNotRanked = "leaderboard_not_ranked";

  // Journal
  static const String menuKeyFoodDiary = "menu_food_diary";
  static const String menuKeyFoodHabit = "menu_food_habit";
  static const String menuKeyExerciseHabit = "menu_exercise_habit";
  static const String habitKeyCompletedTitle = "habit_completed_title";
  static const String habitKeyCompletedMsg = "habit_completed_msg";
  static const String habitKeyBackToJournal = "habit_back_to_journal";
  static const String menuKeyStartJournalling = "menu_start_journalling";
  static const String menuKeyReward = "menu_reward";
  static const String menuKeyWriteJournal = "menu_write_journal";
  static const String menuKeyPointsReward = "menu_points_reward";

  // Recipes
  static const String recipeKeyGuide = "recipe_guide";

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
  static const String commonKeyYes = "common_yes";
  static const String commonKeyNo = "common_no";
  static const String commonKeyNoRooms = "common_no_rooms";
  static const String commonKeySearchPlaceholder = "common_search_placeholder";

  // Food
  static const String foodKeyAddFood = "food_add_food";
  static const String foodKeyGram = "food_gram";
  static const String foodKeyInputGram = "food_input_gram";
  static const String foodKeyGramRequired = "food_gram_required";
  static const String foodKeyNoProgress = "food_no_progress";
  static const String foodKeyNoDataChart = "food_no_data_chart";
  static const String foodKeyEnergyExpenditure = "food_energy_expenditure";
  static const String foodKeyTotalDailyNeeds = "food_total_daily_needs";
  static const String foodKeyTargetIntake = "food_target_intake";
  static const String foodKeyDailyGoal = "food_daily_goal";
  static const String foodKeyActualIntake = "food_actual_intake";
  static const String foodKeyEnergyConsumed = "food_energy_consumed";
  static const String foodKeyAnalyzeSave = "food_analyze_save";
  static const String foodKeyRequirementKcal = "food_requirement_kcal";
  static const String foodKeyTargetKcal = "food_target_kcal";
  static const String foodKeyActualKcal = "food_actual_kcal";
  static const String foodKeyWelcome = "food_welcome";
  static const String foodKeyWelcomeSub = "food_welcome_sub";
  static const String foodKeyJournalDate = "food_journal_date";
  static const String foodKeySelectDate = "food_select_date";
  static const String foodKeyNoMeals = "food_no_meals";
  static const String foodKeyShowLess = "food_show_less";
  static const String foodKeyViewAll = "food_view_all";
  static const String foodKeyTotalIntake = "food_total_intake";
  static const String foodKeyActivityLevel = "food_activity_level";
  static const String foodKeyItems = "food_items";
  static const String foodKeyDesiredEnergyZero = "food_desired_energy_zero";

  // Food Types
  static const String foodTypeBreakfast = "food_type_breakfast";
  static const String foodTypeMorningSnack = "food_type_morning_snack";
  static const String foodTypeLunch = "food_type_lunch";
  static const String foodTypeAfternoonSnack = "food_type_afternoon_snack";
  static const String foodTypeDinner = "food_type_dinner";

  // Activity Levels
  static const String activitySedentary = "activity_sedentary";
  static const String activityLowActive = "activity_low_active";
  static const String activityActive = "activity_active";
  static const String activityVeryActive = "activity_very_active";

  // Habit
  static const String habitKeyDailyJournal = "habit_daily_journal";
  static const String habitKeyConsistency = "habit_consistency";
  static const String habitKeySubmit = "habit_submit";
  static const String habitKeyCompleteAll = "habit_complete_all";
  static const String habitKeyFoodHabit = "habit_food_habit";
  static const String habitKeyShowLess = "habit_show_less";
  static const String habitKeyViewMore = "habit_view_more";
  static const String habitKeyIncomplete = "habit_incomplete";

  // Schedule
  static const String scheduleKeyNoAppointments = "schedule_no_appointments";

  // Profile
  static const String profileKeyEditProfile = "profile_edit";

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

  static String getDayName(String englishDay) {
    switch (englishDay.toLowerCase()) {
      case "monday": return get(dayKeyMonday);
      case "tuesday": return get(dayKeyTuesday);
      case "wednesday": return get(dayKeyWednesday);
      case "thursday": return get(dayKeyThursday);
      case "friday": return get(dayKeyFriday);
      case "saturday": return get(dayKeySaturday);
      case "sunday": return get(dayKeySunday);
      default: return englishDay;
    }
  }

  // ============= STRINGS MAP =============
  static const Map<String, Map<String, String>> _strings = {
    "en": {
      // Auth messages
      "auth_registering": "Creating your account...",
      "auth_logging_in": "Logging in...",
      "auth_verifying_otp": "Verifying OTP...",
      "auth_resending_otp": "Resending OTP...",
      "auth_sending_reset": "Sending reset link...",
      "auth_resetting_password": "Resetting password...",
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
      "forgot_otp": "OTP",
      "forgot_new_password": "New Password",
      "forgot_confirm_password": "Confirm Password",

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
      "nutrition_select_date": "Select Date",
      "nutrition_welcome": "Welcome to your self-monitoring page!",
      "nutrition_bodyweight_monitoring": "Bodyweight Monitoring",
      "nutrition_date_measurement": "Date of Measurement",
      "nutrition_no_data": "No data yet. Start tracking above!",
      "nutrition_weekly_reminder": "Record your body weight at least once a week!",

      // Edutainment
      "edu_welcome": "Enjoy the video and get the reward point!",
      "edu_no_videos": "No videos found.",
      "edu_duration": "Duration",
      "edu_minutes": "minutes",

      // Sleep
      "sleep_welcome": "Track your sleep for a better rest.",
      "sleep_target": "Target Sleep",
      "sleep_actual": "Actual Sleep",
      "sleep_hours": "hours",
      "sleep_no_data": "No sleep data recorded yet.",
      "sleep_no_records": "No sleep records found",
      "sleep_sleeping_duration": "Sleeping duration",
      "sleep_target_label": "Target",

      // Reminder
      "reminder_no_reminders": "No reminders set yet.",
      "reminder_add_reminder": "Add New Reminder",
      "reminder_add": "Add Reminder",
      "reminder_name": "Reminder Name",
      "reminder_time": "Time",
      "reminder_frequency": "Frequency",
      "reminder_every_day": "Every Day",
      "reminder_delete_confirm_title": "Delete Reminder",
      "reminder_delete_confirm_message": "Are you sure you want to delete this reminder?",
      "reminder_tap_to_change": "Tap to change time",
      "reminder_creating": "Creating reminder...",
      "reminder_updating": "Updating reminder...",
      "reminder_deleting": "Deleting reminder...",

      // Days
      "day_monday": "Monday",
      "day_tuesday": "Tuesday",
      "day_wednesday": "Wednesday",
      "day_thursday": "Thursday",
      "day_friday": "Friday",
      "day_saturday": "Saturday",
      "day_sunday": "Sunday",

      // Merchandise
      "merch_title": "Redeem Points",
      "merch_points": "Points",
      "merch_claim": "Claim Now",
      "merch_no_merch": "No merchandise available currently.",

      // Profile
      "profile_info": "Information",
      "profile_settings": "Settings",
      "profile_change_photo": "Change Photo",
      "profile_sign_out": "Sign Out",
      "profile_language": "Language",
      "profile_select_language": "Select Language",
      "profile_nickname": "Nickname",
      "profile_gender_label": "Gender",
      "profile_change_photo_title": "Change Photo",
      "profile_selected_photo": "Selected Photo",

      // Community
      "forum_title": "Feeds",
      "forum_take_photo": "Take Photo",
      "forum_post_content": "Post Content",
      "forum_like": "Like",
      "forum_comment": "Comment",
      "forum_share": "Share",
      "forum_write_comment": "Write a comment...",
      "forum_posts": "Posts",
      "forum_followers": "Followers",
      "forum_following": "Following",
      "forum_no_posts": "No posts yet.",
      "forum_no_comments": "No comments yet.",

      // Menu / Navigation
      "menu_home": "Home",
      "menu_community": "Feeds",
      "menu_schedule": "Schedule",
      "menu_profile": "Profile",
      "menu_journal_title": "Journal",
      "menu_features": "Features",
      "menu_see_all": "See All",
      "menu_games": "Games",
      "menu_all_games": "All Games",
      "menu_all_features": "All Features",
      "menu_monitoring": "Monitoring",
      "menu_appointment": "Counselor",
      "menu_chat_counselor": "Chat with Counselor",
      "menu_book_now": "Consult Now",
      "menu_schedule_appointment": "Make Appointment",
      "menu_chat_wa": "Chat via WhatsApp",
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
      "leaderboard_title": "Leaderboard",
      "leaderboard_top_players": "Top Players",
      "leaderboard_your_position": "Your Position",
      "leaderboard_other_players": "Other Players",
      "leaderboard_no_data": "No data available yet",
      "leaderboard_not_ranked": "Not ranked yet",

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
      "common_yes": "Yes",
      "common_no": "No",
      "common_success": "Success",
      "common_error": "An error occurred",
      "common_token_not_found": "Token not found. Please log in again.",
      "common_exit_press_again": "Press back again to exit",
      "common_unknown": "Unknown",
      "common_not_set": "Not set",
      "common_no_data_available": "No data available",
      "common_invalid_input": "Invalid input",
      "common_claiming_point": "Claiming point...",
      "common_processing": "Processing...",
      "common_loading": "Loading...",
      "common_autofill": "Autofill",
      "common_play": "Play",
      "common_claim": "Claim",
      "snack_otp_resent": "OTP Resent successfully",
      "snack_point_claimed": "Point claimed successfully!",
      "snack_load_failed": "Failed to load data",
      "snack_error_loading": "Error loading data",
      "appointment_prof_not_selected": "Professional not selected",
      "appointment_details_incomplete": "Please complete all appointment details",
      "common_no_rooms": "No Rooms",
      "common_search_placeholder": "Search here...",

      // Food
      "food_add_food": "Add Food",
      "food_gram": "Gram",
      "food_input_gram": "Input gram",
      "food_gram_required": "Gram amount is required",
      "food_no_progress": "No progress data available",

      // Profile
      "profile_edit": "Edit Profile",

      // Exercise
      "exercise_question": "Question",
      "exercise_of": "of",

      // Chat
      "chat_type_message": "Type a message",
      "common_search_food": "Search food...",

      // Common
      "common_enter_title": "Enter title...",

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

      // Permissions
      "common_permission_required": "Permission Required",
      "common_permission_message": "Application requires permission for this feature. Please enable in settings.",
      "common_open_settings": "Open Settings",

      // Exercise
      "exercise_no_questions": "No exercise questions available",
      "exercise_confirm_exit": "Confirm Exit",
      "exercise_exit_message": "By exiting, your current progress will be lost. Are you sure?",
      "exercise_weekly_quiz": "Weekly Exercise Journal",
      "exercise_unknown_type": "Unknown question type",

      // Food
      "food_no_data_chart": "There are currently no food diaries available.",
      "food_energy_expenditure": "Energy Expenditure",
      "food_total_daily_needs": "Total Daily Needs",
      "food_target_intake": "Target Intake",
      "food_daily_goal": "Daily Goal",
      "food_actual_intake": "Actual Intake",
      "food_energy_consumed": "Energy Consumed",
      "food_analyze_save": "Analyze & Save Journal",
      "food_requirement_kcal": "Requirement (Kcal)",
      "food_target_kcal": "Target (Kcal)",
      "food_actual_kcal": "Actual (Kcal)",
      "food_welcome": "Welcome to Your Food Diary!",
      "food_welcome_sub": "Track your nutrition to reach your goals.",
      "food_journal_date": "Journal Date",
      "food_select_date": "Select Date",
      "food_no_meals": "No meals added yet",
      "food_show_less": "Show less",
      "food_view_all": "View all",
      "food_total_intake": "Total Daily Intake",
      "food_activity_level": "Activity Level",
      "food_items": "items",
      "food_desired_energy_zero": "Desired energy cannot be zero.",

      // Food Types
      "food_type_breakfast": "Breakfast",
      "food_type_morning_snack": "Morning Snack",
      "food_type_lunch": "Lunch",
      "food_type_afternoon_snack": "Afternoon Snack",
      "food_type_dinner": "Dinner",

      // Activity Levels
      "activity_sedentary": "Sedentary",
      "activity_low_active": "Low Active",
      "activity_active": "Active",
      "activity_very_active": "Very Active",

      // Habit
      "habit_daily_journal": "Daily Food Habit Journal",
      "habit_completed_title": "Today's Journal Complete!",
      "habit_completed_msg": "Thank you for recording your habits today. Keep up the spirit for a healthier life!",
      "habit_back_to_journal": "Back to Journal",
      "habit_consistency": "Consistency is key to a healthier life.",
      "habit_submit": "Submit Journal",
      "habit_complete_all": "Complete All",
      "habit_food_habit": "Food Habit",
      "habit_show_less": "Show Less",
      "habit_view_more": "View More Questions",
      "habit_incomplete": "Oops! Make sure all questions have been answered.",

      // Schedule
      "schedule_no_appointments": "No upcoming appointments",

      // Menu
      "menu_points_reward": "points",
      "common_points_label": "pts",
      "exercise_finish": "Finish Journal",
      "exercise_next": "Next",

      // Recipes
      "recipe_guide": "Recipe Guide",
    },
    "id": {
      // Auth messages
      "auth_registering": "Membuat akun Anda...",
      "auth_logging_in": "Sedang masuk...",
      "auth_verifying_otp": "Memverifikasi OTP...",
      "auth_resending_otp": "Mengirim ulang OTP...",
      "auth_sending_reset": "Mengirim link reset...",
      "auth_resetting_password": "Mereset kata sandi...",
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
      "forgot_otp": "OTP",
      "forgot_new_password": "Kata Sandi Baru",
      "forgot_confirm_password": "Konfirmasi Kata Sandi",

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
      "nutrition_select_date": "Pilih Tanggal",
      "nutrition_welcome": "Selamat datang di halaman pemantauan diri!",
      "nutrition_bodyweight_monitoring": "Pemantauan Berat Badan",
      "nutrition_date_measurement": "Tanggal Pengukuran",
      "nutrition_no_data": "Belum ada data. Mulai melacak di atas!",
      "nutrition_weekly_reminder": "Catat berat badan Anda minimal seminggu sekali!",

      // Edutainment
      "edu_welcome": "Nikmati videonya dan dapatkan poin hadiah!",
      "edu_no_videos": "Video tidak ditemukan.",
      "edu_duration": "Durasi",
      "edu_minutes": "menit",

      // Sleep
      "sleep_welcome": "Pantau tidur Anda untuk istirahat yang lebih baik.",
      "sleep_target": "Target Tidur",
      "sleep_actual": "Tidur Aktual",
      "sleep_hours": "jam",
      "sleep_no_data": "Belum ada data tidur yang tercatat.",
      "sleep_no_records": "Belum ada catatan tidur",
      "sleep_sleeping_duration": "Durasi tidur",
      "sleep_target_label": "Target",

      // Reminder
      "reminder_no_reminders": "Belum ada pengingat yang disetel.",
      "reminder_add_reminder": "Tambah Pengingat Baru",
      "reminder_add": "Tambah Pengingat",
      "reminder_name": "Nama Pengingat",
      "reminder_time": "Waktu",
      "reminder_frequency": "Frekuensi",
      "reminder_every_day": "Setiap Hari",
      "reminder_delete_confirm_title": "Hapus Pengingat",
      "reminder_delete_confirm_message": "Apakah Anda yakin ingin menghapus pengingat ini?",
      "reminder_tap_to_change": "Ketuk untuk mengubah waktu",
      "reminder_creating": "Membuat pengingat...",
      "reminder_updating": "Memperbarui pengingat...",
      "reminder_deleting": "Menghapus pengingat...",

      // Days
      "day_monday": "Senin",
      "day_tuesday": "Selasa",
      "day_wednesday": "Rabu",
      "day_thursday": "Kamis",
      "day_friday": "Jumat",
      "day_saturday": "Sabtu",
      "day_sunday": "Minggu",

      // Merchandise
      "merch_title": "Tukarkan Poin",
      "merch_points": "Poin",
      "merch_claim": "Klaim Sekarang",
      "merch_no_merch": "Belum ada merchandise yang tersedia saat ini.",

      // Profile
      "profile_info": "Informasi",
      "profile_settings": "Pengaturan",
      "profile_change_photo": "Ubah Foto",
      "profile_sign_out": "Keluar",
      "profile_language": "Bahasa",
      "profile_select_language": "Pilih Bahasa",
      "profile_nickname": "Nama Panggilan",
      "profile_gender_label": "Jenis Kelamin",
      "profile_change_photo_title": "Ubah Foto",
      "profile_selected_photo": "Foto Terpilih",

      // Community
      "forum_title": "Feeds",
      "forum_take_photo": "Ambil Foto",
      "forum_post_content": "Posting Konten",
      "forum_like": "Suka",
      "forum_comment": "Komentar",
      "forum_share": "Bagikan",
      "forum_write_comment": "Tulis komentar...",
      "forum_posts": "Postingan",
      "forum_followers": "Pengikut",
      "forum_following": "Mengikuti",
      "forum_no_posts": "Belum ada postingan.",
      "forum_no_comments": "Belum ada komentar.",

      // Menu / Navigation
      "menu_home": "Beranda",
      "menu_community": "Feeds",
      "menu_schedule": "Jadwal",
      "menu_profile": "Profil",
      "menu_journal_title": "Jurnal",
      "menu_features": "Fitur",
      "menu_see_all": "Lihat Semua",
      "menu_games": "Permainan",
      "menu_all_games": "Semua Permainan",
      "menu_all_features": "Semua Fitur",
      "menu_monitoring": "Pemantauan",
      "menu_appointment": "Konselor",
      "menu_chat_counselor": "Chat dengan Konselor",
      "menu_book_now": "Konsultasi Sekarang",
      "menu_schedule_appointment": "Buat Janji Temu",
      "menu_chat_wa": "Chat via WhatsApp",
      "menu_edutainment": "Edutainment",
      "menu_game": "Permainan",
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
      "leaderboard_title": "Papan Peringkat",
      "leaderboard_top_players": "Pemain Teratas",
      "leaderboard_your_position": "Posisi Anda",
      "leaderboard_other_players": "Pemain Lainnya",
      "leaderboard_no_data": "Belum ada data tersedia",
      "leaderboard_not_ranked": "Belum berperingkat",

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
      "common_yes": "Ya",
      "common_no": "Tidak",
      "common_success": "Berhasil",
      "common_error": "Terjadi kesalahan",
      "common_token_not_found": "Token tidak ditemukan. Silakan login kembali.",
      "common_exit_press_again": "Tekan sekali lagi untuk keluar",
      "common_unknown": "Tidak diketahui",
      "common_not_set": "Belum diatur",
      "common_no_data_available": "Tidak ada data tersedia",
      "common_invalid_input": "Input tidak valid",
      "common_claiming_point": "Mengklaim poin...",
      "common_processing": "Memproses...",
      "common_loading": "Memuat...",
      "common_autofill": "Otomatis",
      "common_play": "Main",
      "common_claim": "Klaim",
      "snack_otp_resent": "OTP berhasil dikirim ulang",
      "snack_point_claimed": "Poin berhasil diklaim!",
      "snack_load_failed": "Gagal memuat data",
      "snack_error_loading": "Terjadi kesalahan saat memuat data",
      "appointment_prof_not_selected": "Profesional belum dipilih",
      "appointment_details_incomplete": "Harap lengkapi semua detail janji temu",
      "common_no_rooms": "Tidak ada Ruangan",
      "common_search_placeholder": "Cari di sini...",

      // Food
      "food_add_food": "Tambah Makanan",
      "food_gram": "Gram",
      "food_input_gram": "Masukkan gram",
      "food_gram_required": "Jumlah gram diperlukan",
      "food_no_progress": "Belum ada data kemajuan",

      // Profile
      "profile_edit": "Edit Profil",

      // Exercise
      "exercise_question": "Pertanyaan",
      "exercise_of": "dari",

      // Chat
      "chat_type_message": "Ketik pesan",
      "common_search_food": "Cari makanan...",

      // Common
      "common_enter_title": "Masukkan judul...",

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

      // Permissions
      "common_permission_required": "Izin Diperlukan",
      "common_permission_message": "Aplikasi memerlukan izin untuk fitur ini. Silakan aktifkan di pengaturan.",
      "common_open_settings": "Buka Pengaturan",

      // Exercise
      "exercise_no_questions": "Belum ada pertanyaan olahraga tersedia",
      "exercise_confirm_exit": "Konfirmasi Keluar",
      "exercise_exit_message": "Dengan keluar, kemajuan Anda saat ini akan hilang. Apakah Anda yakin?",
      "exercise_daily_quiz": "Jurnal Olahraga Mingguan",
      "exercise_unknown_type": "Tipe pertanyaan tidak diketahui",

      // Food
      "food_no_data_chart": "Belum ada catatan makanan yang tersedia saat ini.",
      "food_energy_expenditure": "Pengeluaran Energi",
      "food_total_daily_needs": "Kebutuhan Harian Total",
      "food_target_intake": "Target Asupan",
      "food_daily_goal": "Target Harian",
      "food_actual_intake": "Asupan Aktual",
      "food_energy_consumed": "Energi yang Dikonsumsi",
      "food_analyze_save": "Analisis & Simpan Jurnal",
      "food_requirement_kcal": "Kebutuhan (Kcal)",
      "food_target_kcal": "Target (Kcal)",
      "food_actual_kcal": "Aktual (Kcal)",
      "food_welcome": "Selamat Datang di Catatan Makanan Anda!",
      "food_welcome_sub": "Pantau nutrisi Anda untuk mencapai tujuan Anda.",
      "food_journal_date": "Tanggal Jurnal",
      "food_select_date": "Pilih Tanggal",
      "food_no_meals": "Belum ada makanan yang ditambahkan",
      "food_show_less": "Tampilkan lebih sedikit",
      "food_view_all": "Lihat semua",
      "food_total_intake": "Total Asupan Harian",
      "food_activity_level": "Tingkat Aktivitas",
      "food_items": "item",
      "food_desired_energy_zero": "Target energi tidak boleh nol.",

      // Food Types
      "food_type_breakfast": "Sarapan",
      "food_type_morning_snack": "Camilan Pagi",
      "food_type_lunch": "Makan Siang",
      "food_type_afternoon_snack": "Camilan Sore",
      "food_type_dinner": "Makan Malam",

      // Activity Levels
      "activity_sedentary": "Sangat Jarang Berolahraga",
      "activity_low_active": "Jarang Berolahraga",
      "activity_active": "Aktif Berolahraga",
      "activity_very_active": "Sangat Aktif Berolahraga",

      // Habit
      "habit_daily_journal": "Jurnal Kebiasaan Makan Harian",
      "habit_completed_title": "Jurnal Hari Ini Selesai!",
      "habit_completed_msg": "Terima kasih sudah mencatat kebiasaanmu hari ini. Teruskan semangatmu untuk hidup lebih sehat!",
      "habit_back_to_journal": "Kembali ke Jurnal",
      "habit_consistency": "Konsistensi adalah kunci hidup yang lebih sehat.",
      "habit_submit": "Simpan Jurnal",
      "habit_complete_all": "Lengkapi Semua",
      "habit_food_habit": "Kebiasaan Makan",
      "habit_show_less": "Tampilkan Lebih Sedikit",
      "habit_view_more": "Lihat Pertanyaan Lagi",
      "habit_incomplete": "Ups! Pastikan semua pertanyaan telah dijawab.",

      // Schedule
      "schedule_no_appointments": "Tidak ada jadwal janji temu",

      // Menu
      "menu_points_reward": "poin",
      "common_points_label": "poin",
      "exercise_finish": "Selesaikan Jurnal",
      "exercise_next": "Lanjut",

      // Recipes
      "recipe_guide": "Panduan Resep",
    }
  };
}
