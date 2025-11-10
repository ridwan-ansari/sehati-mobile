import 'package:get/get.dart';
import 'package:sehati/app/modules/auth/controllers/auth_controller.dart';
import 'package:sehati/app/modules/auth/views/next_step/input_profile_page.dart';
import 'package:sehati/app/modules/auth/views/next_step/nutritional_status_page.dart';
import 'package:sehati/app/modules/auth/views/next_step/verify_otp_page.dart';
import 'package:sehati/app/modules/auth/views/signup_page.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/widget/profile_draft.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/appointment/views/appointment_detail_page.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/views/add_room_chat_page.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/views/chat_private_page.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/food_diary/bindings/food_diary_binding.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/food_diary/views/food_diary_page.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/food_habit/bindings/food_habit_binding.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/food_habit/views/food_habit_page.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/reminder/views/add_reminder_page.dart';
import 'package:sehati/app/modules/splash_page.dart';
import 'package:sehati/app/routes/app_routes.dart';
import '../modules/auth/views/login_page.dart';
import '../modules/dashboard/views/dashboard_page.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';

// ===== Home Feature Imports =====
import '../modules/dashboard/views/feature/home/monitoring/views/monitoring_page.dart';
import '../modules/dashboard/views/feature/home/appointment/views/appointment_page.dart';
import '../modules/dashboard/views/feature/home/edutainment/views/edutainment_page.dart';
import '../modules/dashboard/views/feature/home/game/views/game_page.dart';
import '../modules/dashboard/views/feature/home/journal/views/journal_page.dart';
import '../modules/dashboard/views/feature/home/chatting/views/chatting_page.dart';
import '../modules/dashboard/views/feature/home/healthy_menu/views/healthy_menu_page.dart';
import '../modules/dashboard/views/feature/home/reminder/views/reminder_page.dart';

import '../modules/dashboard/views/feature/home/monitoring/bindings/monitoring_binding.dart';
import '../modules/dashboard/views/feature/home/appointment/bindings/appointment_binding.dart';
import '../modules/dashboard/views/feature/home/edutainment/bindings/edutainment_binding.dart';
import '../modules/dashboard/views/feature/home/game/bindings/game_binding.dart';
import '../modules/dashboard/views/feature/home/journal/bindings/journal_binding.dart';
import '../modules/dashboard/views/feature/home/chatting/bindings/chatting_binding.dart';
import '../modules/dashboard/views/feature/home/healthy_menu/bindings/healthy_menu_binding.dart';
import '../modules/dashboard/views/feature/home/reminder/bindings/reminder_binding.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.SPLASH, page: () => const SplashPage()),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.SIGNUP,
      page: () => const RegisterPage(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.NUTRITION,
      page: () => const NutritionalStatusPage(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.INPUTPROFILE,
      page: () => const InputProfilePage(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),

    // ==== Home Feature Routes ====
    GetPage(
      name: AppRoutes.MONITORING,
      page: () => const MonitoringPage(),
      binding: MonitoringBinding(),
    ),
    GetPage(
      name: AppRoutes.APPOINTMENT,
      page: () => const AppointmentPage(),
      binding: AppointmentBinding(),
    ),
    GetPage(
      name: AppRoutes.EDUTAINMENT,
      page: () => const EdutainmentPage(),
      binding: EdutainmentBinding(),
    ),
    GetPage(
      name: AppRoutes.GAME,
      page: () => const GamePage(),
      binding: GameBinding(),
    ),
    GetPage(
      name: AppRoutes.JOURNAL,
      page: () => const JournalPage(),
      binding: JournalBinding(),
    ),
    GetPage(
      name: AppRoutes.CHATTING,
      page: () => const ChattingPage(),
      binding: ChattingBinding(),
    ),
    GetPage(
      name: AppRoutes.HEALTHY_MENU,
      page: () => const HealthyMenuPage(),
      binding: HealthyMenuBinding(),
    ),
    GetPage(
      name: AppRoutes.REMINDER,
      page: () => const ReminderPage(),
      binding: ReminderBinding(),
    ),
    GetPage(
      name: AppRoutes.APPOINTMENT_DETAIL,
      page: () => const AppointmentDetailPage(),
      binding: AppointmentBinding(),
    ),
    GetPage(
      name: AppRoutes.FOOD_DIARY,
      page: () => const FoodDiaryPage(),
      binding: FoodDiaryBinding(),
    ),
    GetPage(
      name: AppRoutes.FOOD_HABIT,
      page: () => const FoodHabitPage(),
      binding: FoodHabitBinding(),
    ),
    GetPage(
      name: AppRoutes.ADD_REMINDER,
      page: () => const AddReminderPage(),
      binding: ReminderBinding(),
    ),
    GetPage(
      name: AppRoutes.ADD_ROOM_CHAT,
      page: () => const AddRoomChatPage(),
      binding: ChattingBinding(),
    ),
    GetPage(
      name: AppRoutes.CHAT_PRIVATE,
      page: () => const ChatPrivatePage(),
      binding: ChattingBinding(),
    ),
    GetPage(
      name: AppRoutes.SOCIAL_PROFILE,
      page: () => const ProfileDraft(),
      binding: ChattingBinding(),
    ),
    GetPage(
      name: AppRoutes.VERIFY_OTP,
      page: () => const VerifyOtpPage(),
      binding: AuthBinding(),
    ),
  ];
}
