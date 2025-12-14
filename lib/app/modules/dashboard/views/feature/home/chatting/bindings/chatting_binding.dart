import 'package:get/get.dart';
import '../controllers/chatting_controller.dart';

class ChattingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChattingController());
  }
}
