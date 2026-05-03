import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
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
        _buildBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            logoSvg: AppAssets.reminderIcon,
            onSearchChanged: (_) {},
            onProfileTap: () {},
          ),
          body: Obx(
            () => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.richBrown,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const AnimatedIn(
                      child: Text(
                        'My Reminders',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: controller.reminders.isEmpty
                        ? const Center(child: Text('No reminders yet.'))
                        : ListView.builder(
                            itemCount: controller.reminders.length,
                            itemBuilder: (context, index) {
                              final reminder = controller.reminders[index];
                              return Dismissible(
                                key: ValueKey(reminder.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                confirmDismiss: (_) async {
                                  final confirmed = await DialogUtils.showConfirmDialog(
                                    context: context,
                                    title: 'Delete Reminder',
                                    message: 'Are you sure you want to delete this reminder?',
                                  );
                                  if (confirmed == true) {
                                    await controller.deleteReminderServer(reminder);
                                    return true;
                                  }
                                  return false;
                                },
                                child: Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  child: ListTile(
                                    leading: _PulsingBellIcon(active: reminder.active),
                                    title: AnimatedIn(
                                      child: Text(
                                        reminder.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                    ),
                                    subtitle: Row(
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
                                            child: Text(
                                              reminder.days.length == 7
                                                  ? 'Every day'
                                                  : reminder.days.join(', '),
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Switch(
                                      value: reminder.active,
                                      onChanged: (_) async {
                                        final updated = reminder.copyWith(
                                          active: !reminder.active,
                                        );
                                        await controller.updateReminderServer(updated);
                                      },
                                      activeTrackColor: AppColors.orangeLight,
                                    ),
                                    onTap: () => Get.toNamed(
                                      '/add_reminder',
                                      arguments: reminder,
                                    ),
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
              decoration: const BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: AppAssetUtils.svg(
                  AppAssets.reminderIcon,
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

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.yellowLight, AppColors.orangeLight],
        ),
      ),
    );
  }
}

class _PulsingBellIcon extends StatefulWidget {
  const _PulsingBellIcon({required this.active});

  final bool active;

  @override
  State<_PulsingBellIcon> createState() => _PulsingBellIconState();
}

class _PulsingBellIconState extends State<_PulsingBellIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.active ? Colors.amber.shade700 : Colors.grey;

    if (!widget.active) {
      return Icon(Icons.notifications_active, color: color, size: 28);
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ScaleTransition(
          scale: _scale,
          child: Icon(Icons.notifications_active, color: color, size: 28),
        ),
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
