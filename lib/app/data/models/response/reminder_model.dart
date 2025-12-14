class Reminder {
  String? id;
  String time;
  String? userId;
  List<String> days;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  String title;
  bool active;
  String message;

  Reminder({
    this.id,
    required this.time,
    this.userId,
    required this.days,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.title,
    required this.active,
    required this.message,
  });

  /// 🔁 COPY / UPDATE DATA
  Reminder copyWith({
    String? id,
    String? time,
    String? userId,
    List<String>? days,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? title,
    bool? active,
    String? message,
  }) {
    return Reminder(
      id: id ?? this.id,
      time: time ?? this.time,
      userId: userId ?? this.userId,
      days: days ?? List<String>.from(this.days),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      title: title ?? this.title,
      active: active ?? this.active,
      message: message ?? this.message,
    );
  }

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
    id: json["id"],
    time: json["time"],
    userId: json["user_id"],
    days: List<String>.from(json["days"] ?? []),
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : null,
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : null,
    deletedAt: json["deleted_at"] != null
        ? DateTime.parse(json["deleted_at"])
        : null,
    title: json["title"],
    active: json["active"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "days": days,
    "title": title,
    "active": active,
    "message": message,
  };
}

/// Model responsenya fleksibel: bisa untuk POST (data tunggal) maupun GET (data list)
class ReminderResponse {
  int statusCode;
  String message;
  List<Reminder>? dataList;
  Reminder? dataItem;

  ReminderResponse({
    required this.statusCode,
    required this.message,
    this.dataList,
    this.dataItem,
  });

  factory ReminderResponse.fromJson(Map<String, dynamic> json) {
    if (json["data"] is List) {
      return ReminderResponse(
        statusCode: json["status_code"],
        message: json["message"],
        dataList: List<Reminder>.from(
          json["data"].map((x) => Reminder.fromJson(x)),
        ),
      );
    } else {
      return ReminderResponse(
        statusCode: json["status_code"],
        message: json["message"],
        dataItem: json["data"] != null ? Reminder.fromJson(json["data"]) : null,
      );
    }
  }
}
