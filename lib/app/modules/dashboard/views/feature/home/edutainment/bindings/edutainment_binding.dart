import 'package:get/get.dart';
import '../controllers/edutainment_controller.dart';

class EdutainmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EdutainmentController>(() => EdutainmentController());
  }
}
