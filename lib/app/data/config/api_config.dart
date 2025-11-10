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
  static const String USER_LIST = "$BASE_URL/api/user/";
  static const String USER_PROFILE = "$BASE_URL/api/user/profile";
  static String userById(int id) => "$BASE_URL/api/user/$id";

  // =========================
  // 💬 CHAT
  // =========================
  static const String CHAT_ROOMS = "$BASE_URL/api/chat/rooms";
  static String chatMessages(String roomKey) => "$BASE_URL/api/chat/messages/$roomKey";

  // =========================
  // 🍽️ USER NUTRITION
  // =========================
  static const String USER_NUTRITION = "$BASE_URL/api/user/nutrition/";

  // =========================
  // 🧑‍💻 ADMIN DASHBOARD
  // =========================
  static const String ADMIN_LOGIN = "$BASE_URL/dashboard/login";
  static const String ADMIN_LOGOUT = "$BASE_URL/dashboard/logout";
  static const String ADMIN_USERS = "$BASE_URL/dashboard/users";
  static String adminUserDetail(int userId) => "$BASE_URL/dashboard/users/$userId";
  static const String ADMIN_RESET_PASSWORD = "$BASE_URL/dashboard/reset/password";
  static const String ADMIN_RESET_PASSWORD_CONFIRM = "$BASE_URL/dashboard/reset/password/confirm";

  // =========================
  // 🌐 ROOT
  // =========================
  static const String ROOT = "$BASE_URL/";
}
