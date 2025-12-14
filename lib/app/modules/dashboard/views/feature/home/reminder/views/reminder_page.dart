// ignore_for_file: deprecated_member_use, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/dialog_utils.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
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
                    child: AnimatedIn(
                      child: Text(
                        "My Reminders",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
                              return Dismissible(
                                key: ValueKey(reminder.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                confirmDismiss: (_) async {
                                  final bool
                                  confirm = await DialogUtils.showConfirmDialog(
                                    context: context,
                                    title: "Delete Reminder",
                                    message:
                                        "Are you sure you want to delete this reminder?",
                                  );

                                  if (confirm == true) {
                                    await controller.deleteReminderServer(
                                      reminder,
                                    );
                                    return true;
                                  }

                                  return false;
                                },

                                child: Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    leading: AnimatedIn(
                                      child: const Icon(
                                        Icons.alarm,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    title: AnimatedIn(
                                      child: Text(reminder.title),
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        AnimatedIn(
                                          child: Text(
                                            reminder.time,
                                            style: const TextStyle(
                                              fontFamily: 'Digital7',
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: AnimatedIn(
                                            child: AnimatedIn(
                                              child: Text(
                                                reminder.days.length == 7
                                                    ? "Every day"
                                                    : reminder.days.join(", "),
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    trailing: Switch(
                                      value: reminder.active,
                                      onChanged: (v) async {
                                        final rmdr = reminder.copyWith(
                                          active: !reminder.active,
                                        );
                                        await controller.updateReminderServer(
                                          rmdr,
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
