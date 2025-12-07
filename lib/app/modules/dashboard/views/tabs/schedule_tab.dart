// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/modules/dashboard/views/feature/schedule/controller/schedule_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/schedule/widget/schedule_card_widget.dart';

class ScheduleTab extends GetView<ScheduleController> {
  const ScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        logoSvg: AppAssets.doctorIcon,
        onProfileTap: () => print("Profile tapped"),
      ),

      body: Obx(() {
        return RefreshIndicator(
          color: AppColors.gold,
          onRefresh: () async {
            await controller.fetchSchedules();
          },

          child: controller.isLoading.value && controller.schedules.isEmpty
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.gold),
                )
              : AnimatedIn(
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 16),
                    itemCount: controller.schedules.length,
                    itemBuilder: (context, index) {
                      final schedule = controller.schedules[index];
                      print("[$index] TIME : ${schedule.scheduleTime}");
                      return ScheduleCardWidget(shedule: schedule);
                    },
                  ),
              ),
        );
      }),
    );
  }
}
