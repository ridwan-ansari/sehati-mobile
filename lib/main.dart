import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sehati/app/data/services/notification_service.dart';
import 'package:sehati/app/services/notification_service.dart';
import 'package:sehati/main_config.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/common/themes/app_theme.dart';
import 'app/global_controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MainConfig().configureLocalTimeZone();
  Get.put(ThemeController());
  runApp(const MRAApp());
  await LocalStorageService.init();
  await NotificationService.init();
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.dark
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false;
}

class MRAApp extends StatelessWidget {
  const MRAApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        title: 'MRA App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        builder: EasyLoading.init(),
        initialRoute: AppRoutes.LOGIN,
        getPages: AppPages.routes,
      ),
    );
  }
}
