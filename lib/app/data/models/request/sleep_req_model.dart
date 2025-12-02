class SleepReqModel {
   String startTime;
   String wakeUpTime;
   int targetSleep;

  SleepReqModel({
    required this.startTime,
    required this.wakeUpTime,
    required this.targetSleep,
  });

  Map<String, dynamic> toJson() {
    return {
      "sleep_time": startTime,
      "wake_up_time": wakeUpTime,
      "target_sleep_hours": targetSleep,
    };
  }
}
