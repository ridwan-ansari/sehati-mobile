// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/data/enum/activity_level.dart';
import 'package:sehati/app/data/enum/food.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/food/widget/food_diary_chart.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/header_title.dart';
import '../controllers/food_diary_controller.dart';

class FoodDiaryPage extends GetView<FoodDiaryController> {
  const FoodDiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildWelcomeHeader(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDatePicker(context),
                    const SizedBox(height: 24),
                    HeaderTitleWidget(title: AppStrings.getOr("Record Your Meals", "Catat Makananmu")),
                    const SizedBox(height: 16),
                    _buildMealSection(context),
                    const SizedBox(height: 24),
                    HeaderTitleWidget(title: AppStrings.getOr("Nutritional Analysis", "Analisis Gizi")),
                    const SizedBox(height: 16),
                    _buildAnalysisSection(),
                    const SizedBox(height: 24),
                    HeaderTitleWidget(title: AppStrings.getOr("Weekly Progress", "Progres Mingguan")),
                    const SizedBox(height: 16),
                    _buildChartSection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 24, 24),
      decoration: const BoxDecoration(
        color: AppColors.richBrown,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: AnimatedIn(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 48), // Balancing IconButton width
                      child: Text(
                        AppStrings.get(AppStrings.menuKeyFoodDiary),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.get(AppStrings.foodKeyWelcome),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              AppStrings.get(AppStrings.foodKeyWelcomeSub),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.orangeLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.calendar_today_rounded, color: AppColors.orangeLight, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.get(AppStrings.foodKeyJournalDate),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                ),
                Obx(() => Text(
                  controller.selectedDate.value.isEmpty ? AppStrings.get(AppStrings.foodKeySelectDate) : controller.selectedDate.value,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark),
                )),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                final formatted = DateFormat('dd/MM/yyyy').format(picked);
                controller.dateController.text = formatted;
                controller.selectedDate.value = formatted;
              }
            },
            icon: const Icon(Icons.edit_calendar_rounded, color: AppColors.orangeLight),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          _buildMealItem(context, FoodType.breakfast),
          const Divider(height: 24),
          _buildMealItem(context, FoodType.morningSnack),
          const Divider(height: 24),
          _buildMealItem(context, FoodType.lunch),
          const Divider(height: 24),
          _buildMealItem(context, FoodType.afternoonSnack),
          const Divider(height: 24),
          _buildMealItem(context, FoodType.dinner),
          const SizedBox(height: 16),
          _buildTotalIntake(),
        ],
      ),
    );
  }

  Widget _buildMealItem(BuildContext context, FoodType type) {
    return Obx(() {
      final items = controller.getFoods(type.label);
      final expanded = controller.isExpanded(type.label);
      final visibleItems = expanded ? items : items.take(2).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type.label.capitalizeFirst!,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textDark),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => controller.openFoodDialog(context, title: type.label),
                icon: const Icon(Icons.add_circle_rounded, color: Colors.green),
              ),
            ],
          ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                AppStrings.get(AppStrings.foodKeyNoMeals),
                style: TextStyle(fontSize: 13, color: Colors.grey.shade400, fontStyle: FontStyle.italic),
              ),
            )
          else ...[
            ...visibleItems.map((item) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${item.name} (${item.calories} Kcal)",
                      style: const TextStyle(fontSize: 14, color: AppColors.textMedium),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.remove_circle_outline_rounded, color: Colors.redAccent, size: 20),
                    onPressed: () => controller.removeFood(type.label, item),
                  ),
                ],
              ),
            )),
            if (items.length > 2)
              TextButton(
                onPressed: () => controller.toggleExpand(type.label),
                child: Text(
                  expanded ? AppStrings.get(AppStrings.foodKeyShowLess) : "${AppStrings.get(AppStrings.foodKeyViewAll)} ${items.length} ${AppStrings.get(AppStrings.foodKeyItems)}",
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.orangeLight),
                ),
              ),
          ],
        ],
      );
    });
  }

  Widget _buildTotalIntake() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.orangeLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.get(AppStrings.foodKeyTotalIntake),
            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.orangeLight),
          ),
          Obx(() => Text(
            "${controller.getTotalCalories()} Kcal",
            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.orangeLight),
          )),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.get(AppStrings.foodKeyActivityLevel),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(() => DropdownButton<ActivityLevel>(
                  value: controller.selectedActivity.value,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ActivityLevel.values.map((level) => DropdownMenuItem(
                    value: level,
                    child: Text(level.label, style: const TextStyle(fontSize: 14)),
                  )).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      controller.selectedActivity.value = val;
                    }
                  },
                )),
              ),
            ],
          ),
          const Divider(height: 32),
          _buildAnalysisField(
            AppStrings.get(AppStrings.foodKeyEnergyExpenditure),
            AppStrings.get(AppStrings.foodKeyTotalDailyNeeds),
            Obx(() => Text(
              "${controller.nutritionCalculator.value?.eer ?? 0} Kcal",
              style: const TextStyle(fontWeight: FontWeight.w800),
            )),
          ),
          const Divider(height: 32),
          _buildAnalysisField(
            AppStrings.get(AppStrings.foodKeyTargetIntake),
            AppStrings.get(AppStrings.foodKeyDailyGoal),
            Container(
              width: 80,
              child: TextField(
                controller: controller.controllerDesiredEnergy,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.orangeLight),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                  hintText: "0.0",
                ),
              ),
            ),
          ),
          const Divider(height: 32),
          _buildAnalysisField(
            AppStrings.get(AppStrings.foodKeyActualIntake),
            AppStrings.get(AppStrings.foodKeyEnergyConsumed),
            Obx(() => Text(
              "${controller.getTotalCalories()} Kcal",
              style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.green),
            )),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => controller.submitDiary(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeLight,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                AppStrings.get(AppStrings.foodKeyAnalyzeSave),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisField(String title, String subtitle, Widget trailing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
        trailing,
      ],
    );
  }

  Widget _buildChartSection() {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(16),
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
      child: Obx(() {
        if (controller.chartData.isEmpty) {
          return Center(child: Text(AppStrings.get(AppStrings.foodKeyNoProgress)));
        }
        return FoodDiaryChart(data: controller.chartData);
      }),
    );
  }
}
