// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/data/enum/activity_level.dart';
import 'package:sehati/app/data/enum/food.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/food/widget/food_diary_chart.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/food/widget/row_input_field.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/gradien_label.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/header_title.dart';
import '../controllers/food_diary_controller.dart';

class FoodDiaryPage extends GetView<FoodDiaryController> {
  const FoodDiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.gold,
        title: Text("Food Diary Journal"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
              ),
              child: AnimatedIn(
                child: const Text(
                  "Welcome to Your Food Diary Journal!",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            RowInputField(
              label: "Date",
              controller: controller.dateController,
              readOnly: true,
              hintText: "Select Date",
              isEditable: false,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  controller.dateController.text = DateFormat(
                    'dd/MM/yyyy',
                  ).format(picked);
                }
              },
            ),

            const SizedBox(height: 16),
            HeaderTitleWidget(title: "Record Your Food Diary!"),
            const SizedBox(height: 8),

            // === FOOD DIARY SECTION ===
            _buildSection(
              actions: const Icon(Icons.menu, color: Colors.black),
              child: Column(
                children: [
                  _buildMealList(
                    FoodType.breakfast.label,
                    "breakfast",
                    onAdd: () async {
                      await controller.openFoodDialog(
                        context,
                        title: FoodType.breakfast.label,
                      );
                    },
                  ),

                  _buildMealList(
                    FoodType.morningSnack.label,
                    "Morning Snack",
                    onAdd: () async {
                      await controller.openFoodDialog(
                        context,
                        title: FoodType.morningSnack.label,
                      );
                    },
                  ),

                  _buildMealList(
                    FoodType.lunch.label,
                    "Lunch",
                    onAdd: () async {
                      await controller.openFoodDialog(
                        context,
                        title: FoodType.lunch.label,
                      );
                    },
                  ),

                  _buildMealList(
                    FoodType.afternoonSnack.label,
                    "Afternoon Snack",
                    onAdd: () async {
                      await controller.openFoodDialog(
                        context,
                        title: FoodType.afternoonSnack.label,
                      );
                    },
                  ),

                  _buildMealList(
                    FoodType.dinner.label,
                    "Dinner",
                    onAdd: () async {
                      await controller.openFoodDialog(
                        context,
                        title: FoodType.dinner.label,
                      );
                    },
                  ),

                  Obx(
                    () => _buildMealRow(
                      "Total Intake",
                      "${controller.getTotalCalories()} Kcal",
                      isTotal: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(height: 16),
            HeaderTitleWidget(title: "Analysis"),
            const SizedBox(height: 8),

            _buildSection(
              actions: const Icon(Icons.menu, color: Colors.black),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Obx(() {
                      return _buildAnalysisRow(
                        label: "Total energy expenditure/day",
                        subtitle: "Total kebutuhan energi dalam sehari",
                        isEdit: false,
                        value: (controller.nutritionCalculator.value?.eer ?? 0)
                            .toString(),
                      );
                    }),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedIn(
                                  child: Text(
                                    "Target energy intake/day",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                AnimatedIn(
                                  child: Text(
                                    "Target energi yang masuk dalam sehari",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),

                              border: Border.all(color: Colors.orange.shade300),
                            ),
                            child: TextFormField(
                              controller: controller.controllerDesiredEnergy,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                hint: Center(
                                  child: const Text(
                                    "0.0",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => _buildAnalysisRow(
                        isEdit: false,
                        label: "Actual energy intake",
                        subtitle: "Aktual energi yang masuk dalam sehari",
                        value: "${controller.actualEnergy()} Kcal",
                      ),
                    ),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedIn(
                                  child: Text(
                                    "Type of activity ",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                AnimatedIn(
                                  child: Text(
                                    "Tingkat aktifitas dalam sehari",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.orange.shade300,
                                ),
                              ),

                              child: DropdownButton<ActivityLevel>(
                                value: controller.selectedActivity.value,
                                underline: SizedBox(),
                                hint: const Text(
                                  "Select Activity",
                                  style: TextStyle(fontSize: 14),
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                items: ActivityLevel.values.map((level) {
                                  return DropdownMenuItem(
                                    value: level,
                                    child: Text(
                                      level.label,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.selectedActivity.value = value;
                                    controller.submitDiary();
                                    controller.actualEnergy.value = controller
                                        .getTotalCalories();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 460,

                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amberAccent.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Obx(() {
                          if (controller.chartData.isEmpty) {
                            return AnimatedIn(
                              child: Text(
                                "There are currently no food diaries available.",
                              ),
                            );
                          }
                          return FoodDiaryChart(data: controller.chartData);
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 56.0),
          ],
        ),
      ),
    );
  }

  Widget _buildMealList(
    String key,
    String title, {
    required VoidCallback? onAdd,
  }) {
    return Obx(() {
      final items = controller.getFoods(key);
      final expanded = controller.isExpanded(key);

      // tampilkan hanya 2 item kalau belum di-expand
      final visibleItems = expanded ? items : items.take(1).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GradientLabel(title: title.capitalizeFirst!, fontSize: 14),
              if (onAdd != null)
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.add_circle, color: Colors.deepPurple),
                  onPressed: onAdd,
                ),
            ],
          ),

          const SizedBox(height: 6),

          // === LIST ITEM ===
          ...visibleItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.orange.shade300,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        "${item.name} (${item.calories} Kcal)",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => controller.removeFood(key, item),
                  ),
                ],
              ),
            ),
          ),

          // === TOGGLE LEBIH DARI 2 ===
          if (items.length > 1)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => controller.toggleExpand(key),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, top: 4),
                      child: Text(
                        expanded ? "Hide" : "View All",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }

  // === Section Container ===
  Widget _buildSection({required Widget child, Widget? actions}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE082), Color(0xFFFFB74D)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Container(child: child)],
      ),
    );
  }

  // === Food Row ===
  Widget _buildMealRow(
    String label,
    String value, {
    bool isTotal = false,
    void Function()? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GradientLabel(title: label, fontSize: 14),
              if (onPressed != null)
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: onPressed,
                  icon: Icon(Icons.add_circle),
                ),
            ],
          ),

          const SizedBox(width: 8.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isTotal ? Colors.orange.shade100 : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
        ],
      ),
    );
  }

  Widget _buildAnalysisRow({
    required String label,
    required String value,
    required bool isEdit,
    required String subtitle,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedIn(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AnimatedIn(
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // === KANAN: VALUE / TEXTFIELD ===
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: isEdit
                  ? AnimatedIn(
                      child: TextFormField(
                        controller: controller,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    )
                  : AnimatedIn(
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
