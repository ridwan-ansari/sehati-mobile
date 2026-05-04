import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/modules/dashboard/views/feature/schedule/controller/schedule_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/schedule/widget/schedule_card_widget.dart';
import 'package:sehati/app/modules/dashboard/controllers/dashboard_controller.dart';

class ScheduleTab extends GetView<ScheduleController> {
  const ScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: CustomAppBar(
        showBackButton: true,
        showProfile: false,
        onBack: () => Get.find<DashboardController>().changeTab(0),
      ),
      body: Obx(() {
        return RefreshIndicator(
          color: AppColors.orangeLight,
          onRefresh: () async {
            await controller.fetchSchedules();
          },
          child: controller.isLoading.value && controller.schedules.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.orangeLight))
              : Column(
                  children: [
                    Expanded(
                      child: controller.schedules.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey.shade300),
                                  const SizedBox(height: 16),
                                  Text(
                                    AppStrings.getOr('No upcoming appointments', 'Tidak ada jadwal janji temu'),
                                    style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(20),
                              itemCount: controller.schedules.length,
                              itemBuilder: (context, index) {
                                final schedule = controller.schedules[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: AnimatedIn(
                                    child: ScheduleCardWidget(shedule: schedule),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
        );
      }),
    );
  }
}
