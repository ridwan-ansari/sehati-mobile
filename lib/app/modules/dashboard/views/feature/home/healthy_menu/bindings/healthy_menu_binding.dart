import 'package:get/get.dart';
import '../controllers/healthy_menu_controller.dart';

class HealthyMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HealthyMenuController>(() => HealthyMenuController());
  }
}
