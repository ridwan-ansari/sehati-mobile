import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/dialog_utils.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import '../controllers/reminder_controller.dart';

class ReminderPage extends GetView<ReminderController> {
  const ReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.surface,
      appBar: CustomAppBar(
        logoSvg: AppAssets.reminderIcon,
        title: AppStrings.get(AppStrings.menuKeyReminder),
        onSearchChanged: (_) {},
        showBackButton: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => controller.reminders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            AppStrings.get(AppStrings.reminderKeyNoReminders),
                            style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: controller.reminders.length,
                      itemBuilder: (context, index) {
                        final reminder = controller.reminders[index];
                        return _buildReminderCard(context, reminder);
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add_reminder'),
        backgroundColor: AppColors.orangeLight,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
    ));
  }

  Widget _buildReminderCard(BuildContext context, reminder) {
    return Dismissible(
      key: ValueKey(reminder.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
      ),
      confirmDismiss: (_) async {
        final confirmed = await DialogUtils.showConfirmDialog(
          context: context,
          title: AppStrings.get(AppStrings.reminderKeyDeleteConfirmTitle),
          message: AppStrings.get(AppStrings.reminderKeyDeleteConfirmMessage),
        );
        if (confirmed == true) {
          await controller.deleteReminderServer(reminder);
          return true;
        }
        return false;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: _PulsingBellIcon(active: reminder.active),
          title: Text(
            reminder.title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: AppColors.textDark,
              letterSpacing: -0.3,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.orangeLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_filled_rounded, size: 14, color: AppColors.orangeLight),
                        const SizedBox(width: 4),
                        Text(
                          reminder.time,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.orangeLight,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                reminder.days.length == 7
                    ? AppStrings.get(AppStrings.reminderKeyEveryDay)
                    : reminder.days.map((d) {
                        final localized = AppStrings.getDayName(d);
                        return localized.length > 3 ? localized.substring(0, 3).toUpperCase() : localized.toUpperCase();
                      }).join(', '),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          trailing: Transform.scale(
            scale: 0.9,
            child: Switch(
              value: reminder.active,
              onChanged: (_) async {
                final updated = reminder.copyWith(active: !reminder.active);
                await controller.updateReminderServer(updated);
              },
              activeColor: AppColors.orangeLight,
              activeTrackColor: AppColors.orangeLight.withValues(alpha: 0.2),
            ),
          ),
          onTap: () => Get.toNamed('/add_reminder', arguments: reminder),
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

class _PulsingBellIconState extends State<_PulsingBellIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.2).animate(
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
    final color = widget.active ? AppColors.orangeLight : Colors.grey.shade300;

    if (!widget.active) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle),
        child: Icon(Icons.notifications_none_rounded, color: color, size: 24),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.orangeLight.withValues(alpha: 0.1), shape: BoxShape.circle),
      child: ScaleTransition(
        scale: _scale,
        child: Icon(Icons.notifications_active_rounded, color: color, size: 24),
      ),
    );
  }
}
