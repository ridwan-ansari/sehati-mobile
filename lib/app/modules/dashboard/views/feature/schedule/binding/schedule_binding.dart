import 'package:get/get.dart';
import 'package:sehati/app/modules/dashboard/views/feature/schedule/controller/schedule_controller.dart';

class ScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleController>(() => ScheduleController());
  }
}
