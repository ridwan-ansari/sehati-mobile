import 'package:get/get.dart';
import 'package:sehati/app/data/models/response/schedule_res_model.dart';
import 'package:sehati/app/data/services/schedule_service.dart';

class ScheduleController extends GetxController {
  final ScheduleService _service = ScheduleService();

  RxBool isLoading = false.obs;
  RxList<ScheduleData> schedules = <ScheduleData>[].obs;

  @override
  void onInit() {
    fetchSchedules();
    super.onInit();
  }

  Future<void> fetchSchedules() async {
    isLoading.value = true;

    final result = await _service.getSchedule();
    if (result != null) {
      schedules.assignAll(result);
    }

    isLoading.value = false;
  }
}
