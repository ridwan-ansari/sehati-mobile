// ignore_for_file: constant_identifier_names

/// Base URL utama API
const String BASE_URL = "https://sehatiapps.web.id";

/// Endpoint API untuk seluruh fitur aplikasi SEHATI
class ApiEndpoints {
  // =========================
  // 🔐 AUTHENTICATION
  // =========================
  static const String REGISTER = "$BASE_URL/api/auth/register";
  static const String LOGIN = "$BASE_URL/api/auth/login";
  static const String REFRESH_TOKEN = "$BASE_URL/api/auth/refresh";
  static const String VERIFY_ACCOUNT = "$BASE_URL/api/auth/verify/account";
  static const String RESET_PASSWORD = "$BASE_URL/api/auth/reset-password";
  static const String RESET_PASSWORD_CONFIRM = "$BASE_URL/api/auth/reset-password/confirm";

  // =========================
  // 👤 USER
  // =========================
  static const String USER_PROFILE = "$BASE_URL/api/users/profile";
  static const String USER_PICTURE = "$BASE_URL/api/users/profile/picture";
  static String userById(int id) => "$BASE_URL/api/user/$id";
  static const String SEARCH_USERS = "$BASE_URL/api/users/";

  // =========================
  // 💬 CHAT
  // =========================
  static const String CHAT_ROOMS = "$BASE_URL/api/chat/rooms";
  static String CHAT_PRIVARE = "$BASE_URL/api/chat/messages";
  static const String LEADERBOARD = '$BASE_URL/api/point/leaderboard';
  static const String RECIPE = '$BASE_URL/api/recipe/';


  // =========================
  // 🍽️ USER NUTRITION
  // =========================
  static const String USER_NUTRITION = "$BASE_URL/api/user/nutrition/";

  // =========================
  // 🍽️ USER SLEEP
  // =========================
  static const String USER_SLEEP = "$BASE_URL/api/sleep/";
  static const String MERCHANDISE = "$BASE_URL/api/merchandise";

  // =========================
  // 🧑‍💻 ADMIN DASHBOARD
  // =========================
  static const String ADMIN_LOGIN = "$BASE_URL/dashboard/login";
  static const String ADMIN_LOGOUT = "$BASE_URL/dashboard/logout";
  static const String ADMIN_USERS = "$BASE_URL/dashboard/users";
  static String adminUserDetail(int userId) => "$BASE_URL/dashboard/users/$userId";
  static const String ADMIN_RESET_PASSWORD = "$BASE_URL/dashboard/reset/password";
  static const String ADMIN_RESET_PASSWORD_CONFIRM = "$BASE_URL/dashboard/reset/password/confirm";
  static const String FOOD_DIARY_ANALYSIS = "$BASE_URL/api/habit/food/diary/analysis";

  static const String VIDEO = "$BASE_URL/api/video/";
  static const String VIDEO_CLAIM_REWARD = "$BASE_URL/api/video/claim-reward";
  static const String PROFESSIONAL_LIST = "$BASE_URL/api/appointment/professionals";
  static const String APPOINTMENT = "$BASE_URL/api/appointment/";


  // =========================
  // 🌐 Journal
  // =========================
  
  static const String EXERCISE_LIST = "$BASE_URL/api/exercise/questions";
  static const String HABIT_LIST = "$BASE_URL/api/habit/food/questions";
  static const String EXERCISE_ANSWER = "$BASE_URL/api/exercise/answers";
  static const String HABIT_ANSWER = "$BASE_URL/api/habit/food/answers";
  static const String FOOD_ANSWER = "$BASE_URL/api/habit/food/diary";
  static const String NUTRITION_LATEST = "$BASE_URL/api/user/nutrition/latest";
  static const String NUTRITION_CALCULATOR  = "$BASE_URL/api/user/nutrition/calculator";
  static const String FOOD = "$BASE_URL/api/habit/food";
  static const String FORUM_CONTENT = "$BASE_URL/api/forum";
  static const String GAME = "$BASE_URL/api/games/";

  // =========================
  // 🌐 ROOT
  // =========================
  static const String ROOT = "$BASE_URL/";
}
