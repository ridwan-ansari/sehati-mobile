// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sehati/app/common/utils/dialog_utils.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/enum/activity_level.dart';
import 'package:sehati/app/data/enum/food.dart';
import 'package:sehati/app/data/models/response/food_diary_analysis_model.dart';
import 'package:sehati/app/data/models/response/nutrition_calculator.dart';
import 'package:sehati/app/data/models/response/nutrition_res_model.dart';
import 'package:sehati/app/data/models/response/profile_response_model.dart';
import 'package:sehati/app/data/services/food_service.dart';
import 'package:sehati/app/data/models/response/food_model.dart';
import 'package:sehati/app/data/services/profile_service.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/food/widget/food_diary_chart.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/search_list_widget.dart';

class FoodDiaryController extends GetxController {
  final dateController = TextEditingController();
  final FoodService _foodService = FoodService();
  final controllerSearch = TextEditingController();
  final controllerDesiredEnergy = TextEditingController();

  final ProfileService _profileService = ProfileService();
  final Rx<ProfileData?> dataProfile = Rx<ProfileData?>(null);
  RxList<FoodModel> foods = <FoodModel>[].obs;

  var foodInput = <String, List<FoodModel>>{}.obs;
  var selectedActivity = ActivityLevel.sedentary.obs;
  var latestNutrition = Rxn<NutritionData>();
  var nutritionCalculator = Rxn<NutritionCalculator>();
  var diaryAnalysis = <FoodDiaryAnalysis>[].obs;
  var chartData = <DiaryChartData>[].obs;
  var expanded = <String, RxBool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    for (var type in FoodType.values) {
      expanded[type.label] = false.obs;
    }
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    loadFoodData();
    loadLatestNutrition();
    loadDiaryAnalysis();
    generateChartData();
  }

  bool isExpanded(String key) {
    return expanded[key]?.value ?? false;
  }

  void ensureKey(String key) {
    if (!expanded.containsKey(key)) {
      expanded[key] = false.obs;
    }
  }

  void toggleExpand(String key) {
    ensureKey(key);
    expanded[key]!.value = !expanded[key]!.value;
  }

  Future<void> loadProfile() async {
    try {
      final profile = await _profileService.getProfile();
      if (profile != null) {
        dataProfile.value = profile;
        print("✅ Profil berhasil dimuat: ${profile.fullname}");
      } else {
        print("⚠️ Profil tidak ditemukan");
      }
    } catch (e) {
      print("❌ Gagal memuat profil: $e");
    } finally {}
  }

  Future<void> loadFoodData() async {
    final result = await _foodService.getFood();
    if (result != null) {
      foods.assignAll(result);
    }
    await loadDiaryAnalysis();
    await generateChartData();
  }

  void addFoodToInput(String key, FoodModel item) {
    if (!foodInput.containsKey(key)) {
      foodInput[key] = [];
    }

    foodInput[key]!.add(item);
    foodInput.refresh();
  }

  Future<void> searchFoodData(String? search) async {
    final result = await _foodService.getFoodSearch(name: search ?? "");
    if (result != null) {
      foods.assignAll(result);
    }
  }

  Future<FoodModel?> openFoodDialog(
    BuildContext context, {
    required String title,
  }) async {
    return DialogUtils.showSearchDialog<FoodModel>(
      context: context,
      title: title,
      content: SearchListWidget<FoodModel>(
        searchC: controllerSearch,
        onSearch: (text) => searchFoodData(text),
        items: foods,
        itemLabel: (e) => "${e.name} (${e.calories} Kcal)",
        onItemSelected: (item) {},
        onAddPressed: (item) {
          addFoodToInput(title, item);
          Navigator.pop(context, item);
        },
      ),
    );
  }

  List<FoodModel> getFoods(String key) {
    return foodInput[key] ?? [];
  }

  int getCalories(String key) {
    return getFoods(key).fold(0, (sum, item) => sum + item.calories);
  }

  int getTotalCalories() {
    return foodInput.values
        .expand((e) => e)
        .fold(0, (sum, item) => sum + item.calories);
  }

  void removeFood(String key, FoodModel item) {
    if (foodInput.containsKey(key)) {
      foodInput[key]!.remove(item);
      foodInput.refresh();
    }
  }

  Future<void> submitDiary() async {
    if (controllerDesiredEnergy.text.trim().isEmpty ||
        controllerDesiredEnergy.text.trim() == "0") {
      SnackbarUtils.show("Desired energy cannot be zero.");
      return;
    }

    final foodService = FoodService();
    final List<Map<String, dynamic>> dataBody = [];
    foodInput.forEach((mealType, listFood) {
      for (var item in listFood) {
        dataBody.add({
          "food_id": item.id,
          "meal_type": mealType,
          "quantity": item.calories,
        });
      }
    });

    final success = await foodService.submitFood(
      activity: selectedActivity.value.name,
      desiredEnergyRequirement: int.parse(controllerDesiredEnergy.text),
      data: dataBody,
    );

    if (success) {
      await calculateNutrition(
        dob: dataProfile.value?.dateOfBirth ?? "",
        gender: dataProfile.value?.gender ?? 'male',
        weight: latestNutrition.value?.weightKg ?? 0.0,
        height: latestNutrition.value?.heightCm ?? 0.0,
      );
      await loadDiaryAnalysis();
      await generateChartData();
    }
  }

  Future<void> loadLatestNutrition() async {
    final result = await _foodService.getLatestNutrition();
    if (result != null) {
      latestNutrition.value = result;
    }
  }

  Future<void> calculateNutrition({
    required String dob,
    required String gender,
    required double weight,
    required double height,
  }) async {
    final result = await _foodService.calculateNutrition(
      dob: dob,
      gender: gender,
      weight: weight,
      height: height,
      activity: selectedActivity.value.name,
    );

    if (result != null) {
      nutritionCalculator.value = result;
    }
  }

  Future<void> loadDiaryAnalysis() async {
    final result = await _foodService.getDiaryAnalysis(limit: 5, offset: 0);
    if (result != null) {
      diaryAnalysis.assignAll(result);
    }
  }

  Future<void> generateChartData() async {
    chartData.clear();

    for (final item in diaryAnalysis) {
      chartData.add(
        DiaryChartData(
          date: item.createdAt,
          requirement: item.energyRequirement,
          target: item.desiredEnergyRequirement,
          actual: item.totalCalories,
        ),
      );
    }
  }

  @override
  void onClose() {
    dateController.dispose();
    controllerSearch.dispose();
    super.onClose();
  }
}
