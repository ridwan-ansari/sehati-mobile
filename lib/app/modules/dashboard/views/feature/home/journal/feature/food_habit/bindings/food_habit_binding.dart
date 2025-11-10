import 'package:get/get.dart';
import '../controllers/food_habit_controller.dart';

class FoodHabitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FoodHabitController());
  }
}
