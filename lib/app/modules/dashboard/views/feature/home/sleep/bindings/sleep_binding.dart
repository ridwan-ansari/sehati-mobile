import 'package:get/get.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/sleep/controller/sleep_controller.dart';
class SleepBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SleepController>(() => SleepController());
  }
}
