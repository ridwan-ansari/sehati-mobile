import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sehati/app/services/fcm_service.dart';
import 'package:sehati/firebase_options.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:sehati/app/data/services/hive_storage_service.dart';
import 'package:sehati/app/data/services/ws/chat_socket_service.dart';
import 'package:sehati/app/services/awesome_notifications_service.dart';
import 'package:sehati/main_config.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/common/themes/app_theme.dart';
import 'app/global_controllers/theme_controller.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Handling a background message: ${message.messageId}");

  // IMPORTANT: We must initialize AwesomeNotifications in the background isolate
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'ws_channel',
      channelName: 'WebSocket Chat',
      channelDescription: 'Channel untuk notifikasi chat',
      importance: NotificationImportance.Max,
    ),
  ]);

  if (message.notification != null) {
    // Catatan: Kita tidak memanggil AwesomeNotifications di sini (background)
    // karena Firebase (OS Android) sudah secara otomatis memunculkan 
    // system tray notification jika payload berisi object `notification`.
    // Jika kita memanggilnya, akan terjadi notifikasi ganda (Double Notification).
    
    // Namun kita tetap bisa melakukan proses background lain di sini jika diperlukan.
    debugPrint("FCM Background: Notifikasi akan ditampilkan oleh sistem.");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await MainConfig().configureLocalTimeZone();
  Get.put(ChatSocketService(), permanent: true);
  await GetStorage.init();
  Get.put(ThemeController());
  await LocalStorageService.init();
  await HiveStorageService.init();

  configLoading();

  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'ws_channel',
      channelName: 'WebSocket Chat',
      channelDescription: 'Channel untuk notifikasi chat',
      importance: NotificationImportance.Max,
    ),
  ]);

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: AwesomeNotificationService.onActionReceived,
  );

  // Initialize FCM service to ask permission and listen in foreground
  await FCMService.init();

  runApp(const MRAApp());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MRAApp extends StatelessWidget {
  const MRAApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        title: 'Sehati',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        initialRoute: AppRoutes.SPLASH,
        getPages: AppPages.routes,
        builder: EasyLoading.init(),
      ),
    );
  }
}
