// ignore_for_file: unnecessary_this

class ProfessionalResponse {
  int? statusCode;
  String? message;
  List<ProfessionalData>? data;

  ProfessionalResponse({this.statusCode, this.message, this.data});

  factory ProfessionalResponse.fromJson(Map<String, dynamic> json) {
    return ProfessionalResponse(
      statusCode: json['status_code'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((e) => ProfessionalData.fromJson(e)).toList()
          : [],
    );
  }
}

class ProfessionalData {
  String? id;
  String? fullname;
  String? phoneNumber;
  String? email;
  String? specialization;
  String? bio;
  String? picture;
  bool? isActive;

  AvailableDays? availableDays;
  AvailableHours? availableHours;

  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ProfessionalData({
    this.id,
    this.fullname,
    this.phoneNumber,
    this.email,
    this.specialization,
    this.bio,
    this.picture,
    this.isActive,
    this.availableDays,
    this.availableHours,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ProfessionalData.fromJson(Map<String, dynamic> json) {
    return ProfessionalData(
      id: json['id'],
      fullname: json['fullname'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      specialization: json['specialization'],
      bio: json['bio'],
      picture: json['picture'],
      isActive: json['is_active'],
      availableDays: json['available_days'] != null
          ? AvailableDays.fromJson(json['available_days'])
          : null,
      availableHours: json['available_hours'] != null
          ? AvailableHours.fromJson(
              json['available_hours'],
              fallbackDays: json['available_days'] is Map<String, dynamic>
                  ? json['available_days'] as Map<String, dynamic>
                  : null,
            )
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}

class AvailableDays {
  bool? monday;
  bool? tuesday;
  bool? wednesday;
  bool? thursday;
  bool? friday;
  bool? saturday;
  bool? sunday;

  AvailableDays({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  factory AvailableDays.fromJson(Map<String, dynamic> json) {
    return AvailableDays(
      monday: json['monday'],
      tuesday: json['tuesday'],
      wednesday: json['wednesday'],
      thursday: json['thursday'],
      friday: json['friday'],
      saturday: json['saturday'],
      sunday: json['sunday'],
    );
  }
}

class AvailableHours {
  static const List<String> weekdayKeys = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  final Map<String, DayHours> schedule;

  AvailableHours({Map<String, DayHours>? schedule})
      : schedule = schedule ?? <String, DayHours>{};

  factory AvailableHours.fromJson(
    Map<String, dynamic> json, {
    Map<String, dynamic>? fallbackDays,
  }) {
    final result = <String, DayHours>{};

    final hasPerDay = weekdayKeys.any((k) => json[k] is Map);

    if (hasPerDay) {
      for (final k in weekdayKeys) {
        final v = json[k];
        if (v is Map) {
          final start = v['start'] as String?;
          final end = v['end'] as String?;
          if (start != null && end != null) {
            result[k] = DayHours(start: start, end: end);
          }
        }
      }
    } else {
      // Legacy flat shape: replicate the single window across days flagged
      // active in available_days. If no flags are provided, replicate across
      // every weekday so callers still see a usable window.
      final start = json['start'] as String?;
      final end = json['end'] as String?;
      if (start != null && end != null) {
        final activeKeys = fallbackDays == null
            ? weekdayKeys
            : weekdayKeys.where((k) => fallbackDays[k] == true).toList();
        for (final k in activeKeys.isEmpty ? weekdayKeys : activeKeys) {
          result[k] = DayHours(start: start, end: end);
        }
      }
    }

    return AvailableHours(schedule: result);
  }

  /// Returns the weekday key for a Dart [DateTime.weekday] (1 = Monday).
  static String? keyForWeekday(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'monday';
      case DateTime.tuesday:
        return 'tuesday';
      case DateTime.wednesday:
        return 'wednesday';
      case DateTime.thursday:
        return 'thursday';
      case DateTime.friday:
        return 'friday';
      case DateTime.saturday:
        return 'saturday';
      case DateTime.sunday:
        return 'sunday';
    }
    return null;
  }

  DayHours? forWeekday(int weekday) {
    final key = keyForWeekday(weekday);
    if (key == null) return null;
    return schedule[key];
  }

  bool isOpenOnWeekday(int weekday) => forWeekday(weekday) != null;

  /// Weekday keys (in Mon→Sun order) for which the professional has a window.
  List<String> get activeWeekdayKeys =>
      weekdayKeys.where(schedule.containsKey).toList();

  bool get isEmpty => schedule.isEmpty;
  bool get isNotEmpty => schedule.isNotEmpty;
}

class DayHours {
  final String start;
  final String end;
  DayHours({required this.start, required this.end});
}
