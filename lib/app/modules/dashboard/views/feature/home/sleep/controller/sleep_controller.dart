import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/common/utils/time_utils.dart';
import 'package:sehati/app/data/models/request/sleep_req_model.dart';
import 'package:sehati/app/data/models/response/nutrition_res_model.dart';
import 'package:sehati/app/data/models/response/sleep_record_response.dart';
import 'package:sehati/app/data/services/sleep_service.dart';

class SleepController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final dateController = TextEditingController();
  final targetSleepController = TextEditingController();
  final durationSleepController = TextEditingController();
  var sleepTime = Rx<TimeOfDay?>(null);
  var wakeUpTime = Rx<TimeOfDay?>(null);

  final _sleepService = SleepService();

  final selectedDate = ''.obs;
  var nutritionList = <NutritionData>[].obs;
  var chartData = <Map<String, dynamic>>[].obs;
  var list = <SleepRecord>[].obs;

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

  void calculateDuration() {
    if (sleepTime.value != null && wakeUpTime.value != null) {
      final start = DateTime(
        2025,
        1,
        1,
        sleepTime.value!.hour,
        sleepTime.value!.minute,
      );
      var end = DateTime(
        2025,
        1,
        1,
        wakeUpTime.value!.hour,
        wakeUpTime.value!.minute,
      );

      if (end.isBefore(start)) {
        end = end.add(const Duration(days: 1));
      }

      final diff = end.difference(start);

      durationSleepController.text = "${diff.inHours}h ${diff.inMinutes % 60}m";
    }
  }

  void loadInitialChart() {
    chartData.clear();
    final firstFive = list.take(5).toList();

    chartData.addAll(
      firstFive.map(
        (item) => {
          "date": item.createdAt,
          "sleepDurationHours": item.sleepDurationHours,
          "targetSleepHours": item.targetSleepHours,
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

    final result = await _sleepService.getUserSleepPaginated(
      limit: limit,
      offset: offset,
    );

    if (result != null && result.isNotEmpty) {
      list.addAll(result);
      offset += limit;
    } else {
      hasMore.value = false;
    }

    isLoadingMore.value = false;
  }

  Future<void> submitSleep() async {
    if (sleepTime.value == null ||
        wakeUpTime.value == null ||
        targetSleepController.text.isEmpty) {
      SnackbarUtils.show(
        "Please enter valid Start Time, Wake Up Time & Target Sleep",
      );
      return;
    }

    final now = DateTime.now();

    DateTime combine(DateTime base, TimeOfDay t) =>
        DateTime(base.year, base.month, base.day, t.hour, t.minute);

    final startDt = combine(now, sleepTime.value!);
    var wakeDt = combine(now, wakeUpTime.value!);

    if (wakeDt.isBefore(startDt)) {
      wakeDt = wakeDt.add(const Duration(days: 1));
    }

    // Convert to UTC untuk server
    final startIso = startDt.toUtc().toIso8601String();
    final wakeIso = wakeDt.toUtc().toIso8601String();

    final request = SleepReqModel(
      startTime: startIso,
      wakeUpTime: wakeIso,
      targetSleep: int.parse(targetSleepController.text),
    );

    final result = await _sleepService.addSleep(request);

    if (result) {
      _initData();
    }
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
