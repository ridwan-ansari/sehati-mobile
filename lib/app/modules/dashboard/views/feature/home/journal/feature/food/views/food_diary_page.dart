// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
              child: const Text(
                "Welcome to Your Food Diary Journal!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 16),

            // === DATE FIELD ===
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
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 12),
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

                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GradientLabel(title: "Type of Activity ", fontSize: 14),
                        Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.orange.shade300),
                          ),
                          child: DropdownButton<ActivityLevel>(
                            value: controller.selectedActivity.value,
                            underline: SizedBox(),
                            items: ActivityLevel.values.map((level) {
                              return DropdownMenuItem(
                                value: level,
                                child: Text(level.label),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedActivity.value = value;
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 12.0),

                  /// TOTAL
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
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  controller.submitDiary();
                },
                child: const Text(
                  "Submit Food Diary",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            HeaderTitleWidget(title: "Analysis"),
            const SizedBox(height: 8),

            // === ANALYSIS SECTION ===
            _buildSection(
              actions: const Icon(Icons.menu, color: Colors.black),
              child: Column(
                children: [
                  Obx(() {
                    return _buildAnalysisRow(
                      label: "Energy Requirement (RDA)/Day",
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
                          child: Text("Desired Energy Requirement"),
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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => _buildAnalysisRow(
                      isEdit: false,
                      label: "Actual Energy Intake",
                      value: "${controller.getTotalCalories()} Kcal",
                    ),
                  ),
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
                          return Text("data kosong");
                        }
                        return FoodDiaryChart(data: controller.chartData);
                      }),
                    ),
                  ),
                ],
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
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // === KIRI: LABEL ===
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
                  ? TextFormField(
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
                    )
                  : Text(
                      value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
