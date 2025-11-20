import 'package:get/get.dart';
import 'package:sehati/app/modules/auth/views/next_step/forgot_password.dart';
import 'package:sehati/app/modules/auth/views/next_step/input_profile_page.dart';
import 'package:sehati/app/modules/auth/views/next_step/nutritional_status_page.dart';
import 'package:sehati/app/modules/auth/views/next_step/verify_otp_page.dart';
import 'package:sehati/app/modules/auth/views/signup_page.dart';
import 'package:sehati/app/modules/dashboard/views/feature/binding/forum_binding.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/view/prepare_post_content.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/view/take_photo_page.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/widget/profile_draft.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/appointment/views/appointment_detail_page.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/views/add_room_chat_page.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/views/chat_private_page.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/exercise/bindings/exercise_habit_binding.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/exercise/views/exercise_page.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/food/bindings/food_diary_binding.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/food/views/food_diary_page.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/habit/bindings/food_habit_binding.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/habit/views/food_habit_page.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/reminder/views/add_reminder_page.dart';
import 'package:sehati/app/modules/dashboard/views/tabs/forum_tab.dart';
import 'package:sehati/app/modules/dashboard/views/tabs/profile_tab.dart';
import 'package:sehati/app/modules/profile/bindings/profile_binding.dart';
import 'package:sehati/app/modules/splash_page.dart';
import 'package:sehati/app/routes/app_routes.dart';
import '../modules/auth/views/login_page.dart';
import '../modules/dashboard/views/dashboard_page.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
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
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 500),
    ),

    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.SIGNUP,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.NUTRITION,
      page: () => const NutritionalStatusPage(),
      binding: AuthBinding(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 350),
    ),
    GetPage(
      name: AppRoutes.INPUTPROFILE,
      page: () => const InputProfilePage(),
      binding: AuthBinding(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 350),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),

    // ==== Home Feature Routes ====
    GetPage(
      name: AppRoutes.MONITORING,
      page: () => const MonitoringPage(),
      binding: MonitoringBinding(),
      transition: Transition.native,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.APPOINTMENT,
      page: () => const AppointmentPage(),
      binding: AppointmentBinding(),
      transition: Transition.native,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.EDUTAINMENT,
      page: () => const EdutainmentPage(),
      binding: EdutainmentBinding(),
      transition: Transition.native,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.GAME,
      page: () => const GamePage(),
      binding: GameBinding(),
      transition: Transition.native,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.JOURNAL,
      page: () => const JournalPage(),
      binding: JournalBinding(),
      transition: Transition.native,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.CHATTING,
      page: () => const ChattingPage(),
      binding: ChattingBinding(),
      transition: Transition.native,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.HEALTHY_MENU,
      page: () => const HealthyMenuPage(),
      binding: HealthyMenuBinding(),
      transition: Transition.native,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.REMINDER,
      page: () => const ReminderPage(),
      binding: ReminderBinding(),
      transition: Transition.native,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.APPOINTMENT_DETAIL,
      page: () => const AppointmentDetailPage(),
      binding: AppointmentBinding(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 350),
    ),
    GetPage(
      name: AppRoutes.FOOD_DIARY,
      page: () => const FoodDiaryPage(),
      binding: FoodDiaryBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.FOOD_HABIT,
      page: () => const FoodHabitPage(),
      binding: FoodHabitBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.ADD_REMINDER,
      page: () => const AddReminderPage(),
      binding: ReminderBinding(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 350),
    ),
    GetPage(
      name: AppRoutes.ADD_ROOM_CHAT,
      page: () => const AddRoomChatPage(),
      binding: ChattingBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.CHAT_PRIVATE,
      page: () => const ChatPrivatePage(),
      binding: ChattingBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.SOCIAL_PROFILE,
      page: () => const ProfileDraft(),
      binding: ChattingBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.VERIFY_OTP,
      page: () => const VerifyOtpPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfileTab(),
      binding: ProfileBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.EXERCISE,
      page: () => const ExerciseView(),
      binding: ExerciseBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.TAKE_PHOTO,
      page: () => const TakePhotoPage(),
      binding: DashboardBinding(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.FORUM,
      page: () => const ForumTab(),
      binding: ForumBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
     GetPage(
      name: AppRoutes.PREPARE_POST_CONTENT,
      page: () => const PreparePostContent(),
      binding: ForumBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
  ];
}
