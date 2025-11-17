import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/common/utils/time_utils.dart';
import 'package:sehati/app/data/models/request/nutrition_req_model.dart';
import 'package:sehati/app/data/models/response/nutrition_res_model.dart';
import 'package:sehati/app/data/services/user_service.dart';

class MonitoringController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final dateController = TextEditingController();
  final resultController = TextEditingController();
  final resultCmController = TextEditingController();
  final imtController = TextEditingController();
  final zScoreController = TextEditingController();
  final idealController = TextEditingController();

  final _userService = UserService();

  final selectedDate = ''.obs;
  var nutritionList = <NutritionData>[].obs;
  var chartData = <Map<String, dynamic>>[].obs;
  var list = <NutritionData>[].obs;

  final limit = 5;
  var offset = 0;

  var isLoadingMore = false.obs;
  var hasMore = true.obs;

  final scrollController = ScrollController();
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    selectedDate.value = TimeUtils.formatShortDate(DateTime.now());
    _initData();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> _initData() async {
    await fetchInitial(); 
    loadInitialChart();
  }

  void loadInitialChart() {
    chartData.clear();
    final firstFive = list.take(5).toList();

    chartData.addAll(
      firstFive.map(
        (item) => {
          "date": item.createdAt,
          "actual": item.weightKg.toDouble(),
          "ideal": item.idealWeightKg.toDouble(),
        },
      ),
    );
  }

 Future<void> fetchInitial() async {
  list.clear();
  offset = 0;
  hasMore.value = true;
  scrollController.addListener(_onScroll);
  await loadMore();
}


  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 50) {
      loadMore();
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;

    final result = await _userService.getUserNutritionPaginated(
      limit: limit,
      offset: offset,
    );

    if (result != null && result.isNotEmpty) {
      print("DATA ${result.length}");
      list.addAll(result);
      offset += limit;
      print("data grafik :${chartData.length}");
    } else {
      hasMore.value = false;
    }

    isLoadingMore.value = false;
  }

  Future<void> submitNutrition() async {
    final weightVal = double.tryParse(resultController.text) ?? 0;
    final heightVal = double.tryParse(resultCmController.text) ?? 0;

    if (weightVal <= 0 || heightVal <= 0) {
      SnackbarUtils.show("Please enter valid weight & height");
      return;
    }

    final request = NutritionCreateRequest(
      weightKg: weightVal,
      heightCm: heightVal,
    );

    final result = await _userService.createNutrition(request);


    if (result != null) {
      // =========== AUTO FILL ===========
      imtController.text = result.bmi.toString();
      zScoreController.text = result.status;
      idealController.text = result.idealWeightKg.toString();
    }
    _initData();
  }

  Future<void> selectDate() async {
    final now = DateTime.now();
    final picked = await Get.dialog<DateTime>(
      Theme(
        data: Theme.of(Get.context!).copyWith(
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.white,
            headerBackgroundColor: Colors.orange,
            headerForegroundColor: Colors.white,
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return Colors.black;
            }),
            todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.orange;
              }
              return Colors.orange.withOpacity(0.2);
            }),
            todayForegroundColor: WidgetStateProperty.all(Colors.white),
            todayBorder: const BorderSide(color: Colors.orange, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            confirmButtonStyle: TextButton.styleFrom(
              foregroundColor: Colors.orange,
            ),
            cancelButtonStyle: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
          ),
        ),
        child: DatePickerDialog(
          initialDate: now,
          firstDate: DateTime(1950),
          lastDate: now,
        ),
      ),
    );

    if (picked != null) {
      selectedDate.value = TimeUtils.formatShortDate(picked);
    }
  }
}
