class SleepRecordResponse {
  final int statusCode;
  final String message;
  final List<SleepRecord> data;
  final int total;

  SleepRecordResponse({
    required this.statusCode,
    required this.message,
    required this.data,
    required this.total,
  });

  factory SleepRecordResponse.fromJson(Map<String, dynamic> json) {
    return SleepRecordResponse(
      statusCode: json['status_code'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => SleepRecord.fromJson(item))
          .toList(),
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
      'total': total,
    };
  }
}

class SleepRecord {
  final String id;
  final DateTime sleepTime;
  final DateTime wakeUpTime;
  final int sleepDurationMinutes;
  final double sleepDurationHours;
  final double targetSleepHours;
  final DateTime createdAt;

  SleepRecord({
    required this.id,
    required this.sleepTime,
    required this.wakeUpTime,
    required this.sleepDurationMinutes,
    required this.sleepDurationHours,
    required this.targetSleepHours,
    required this.createdAt,
  });

  factory SleepRecord.fromJson(Map<String, dynamic> json) {
    return SleepRecord(
      id: json['id'],
      sleepTime: DateTime.parse(json['sleep_time']),
      wakeUpTime: DateTime.parse(json['wake_up_time']),
      sleepDurationMinutes: json['sleep_duration_minutes'],
      sleepDurationHours: (json['sleep_duration_hours'] as num).toDouble(),
      targetSleepHours: (json['target_sleep_hours'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sleep_time': sleepTime.toIso8601String(),
      'wake_up_time': wakeUpTime.toIso8601String(),
      'sleep_duration_minutes': sleepDurationMinutes,
      'sleep_duration_hours': sleepDurationHours,
      'target_sleep_hours': targetSleepHours,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
