import 'package:get/get.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/controller/camera_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/controller/forum_controller.dart';

class ForumBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForumController>(() => ForumController());

    Get.put(CameraControllerX());
  }
}
