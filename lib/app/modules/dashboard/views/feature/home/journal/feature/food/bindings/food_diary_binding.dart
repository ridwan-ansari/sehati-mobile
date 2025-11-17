import 'package:get/get.dart';
import '../controllers/food_diary_controller.dart';

class FoodDiaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodDiaryController>(() => FoodDiaryController());
  }
}
