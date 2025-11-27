import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
class MenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuController>(() => MenuController());
  }
}
