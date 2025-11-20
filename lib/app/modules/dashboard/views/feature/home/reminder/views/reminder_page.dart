// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/data/models/reminder_model.dart';
import '../controllers/reminder_controller.dart';

class ReminderPage extends GetView<ReminderController> {
  const ReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _background(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            logoSvg: AppAssets.riminderIcon,
            onSearchChanged: (_) {},
            onProfileTap: () {},
          ),
          body: Obx(
            () => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // HEADER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "My Reminders — Points: ${controller.totalPoints.value}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // LIST REMINDERS
                  Expanded(
                    child: controller.reminders.isEmpty
                        ? const Center(child: Text("No reminders yet."))
                        : ListView.builder(
                            itemCount: controller.reminders.length,
                            itemBuilder: (context, index) {
                              final reminder = controller.reminders[index];
                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.alarm,
                                    color: Colors.orange,
                                  ),
                                  title: Text(reminder.title),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        reminder.time,
                                        style: const TextStyle(
                                          fontFamily: 'Digital7',
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          reminder.days.length == 7
                                              ? "Setiap hari"
                                              : reminder.days.join(", "),
                                          style: const TextStyle(
                                            color: Colors.black54,
                                          ),
                                          overflow: TextOverflow
                                              .ellipsis, // ⬅️ potong otomatis pakai “...”
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),

                                  trailing: Switch(
                                    value: reminder.isActive,
                                    onChanged: (v) {
                                      controller.toggleActive(index, v);
                                      controller.updateReminder(
                                        ReminderModel(
                                          id: reminder.id,
                                          title: reminder.title,
                                          time: reminder.time,
                                          days: reminder.days,
                                          isActive: v,
                                        ),
                                      );
                                    },

                                    activeColor: Colors.orange,
                                  ),
                                  onTap: () {
                                    final reminder =
                                        controller.reminders[index];
                                    Get.toNamed(
                                      '/add_reminder',
                                      arguments: reminder,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: IconButton(
            onPressed: () => Get.toNamed('/add_reminder'),
            icon: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFC107),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: AppAssetUtils.svg(
                  AppAssets.riminderIcon,
                  width: 30,
                  height: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // icon: const Icon(Icons.add_alarm),
          // label: const Text("Add Alarm"),
        ),
      ],
    );
  }

  Widget _background() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFD84E), Color(0xFFFF9A3D)],
        ),
      ),
    );
  }
}
