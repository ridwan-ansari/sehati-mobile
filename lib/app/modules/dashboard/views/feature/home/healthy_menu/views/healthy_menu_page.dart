import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/healthy_menu_controller.dart';

class HealthyMenuPage extends GetView<HealthyMenuController> {
  const HealthyMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Healthy Menu')),
      body: const Center(child: Text('Healthy Menu Page')),
    );
  }
}
