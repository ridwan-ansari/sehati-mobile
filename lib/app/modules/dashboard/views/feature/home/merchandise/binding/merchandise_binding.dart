import 'package:get/get.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/merchandise/controller/merchandise_controller.dart';

class MerchandiseBinding extends Bindings {
  @override
  void dependencies() {
     Get.put<MerchandiseController>(MerchandiseController());
  }
}
