class SleepReqModel {
  final String startTime;
  final String wakeUpTime;
  final int targetSleep;

  SleepReqModel({
    required this.startTime,
    required this.wakeUpTime,
    required this.targetSleep,
  });

  Map<String, dynamic> toJson() {
    return {
      "start_time": startTime,
      "wake_up_time": wakeUpTime,
      "target_sleep_minutes": targetSleep,
    };
  }
}
