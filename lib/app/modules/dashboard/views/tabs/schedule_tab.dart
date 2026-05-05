import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/modules/dashboard/views/feature/schedule/controller/schedule_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/schedule/widget/schedule_card_widget.dart';

class ScheduleTab extends GetView<ScheduleController> {
  const ScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Obx(() {
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
                                    Icon(Icons.calendar_today_outlined,
                                        size: MediaQuery.of(context).size.width * 0.15,
                                        color: Colors.grey.shade300),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                    Text(
                                      AppStrings.get(AppStrings.scheduleKeyNoAppointments),
                                      style: TextStyle(
                                          color: Colors.grey.shade400, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.width * 0.05,
                                  MediaQuery.of(context).size.width * 0.05,
                                  MediaQuery.of(context).size.width * 0.05,
                                  MediaQuery.of(context).size.height * 0.15,
                                ),
                                itemCount: controller.schedules.length,
                                itemBuilder: (context, index) {
                                  final schedule = controller.schedules[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).size.height * 0.02),
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
      ),
    );
  }
}
