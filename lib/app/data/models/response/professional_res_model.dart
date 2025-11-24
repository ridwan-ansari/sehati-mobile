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
          ? AvailableHours.fromJson(json['available_hours'])
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
  String? start;
  String? end;

  AvailableHours({this.start, this.end});

  factory AvailableHours.fromJson(Map<String, dynamic> json) {
    return AvailableHours(
      start: json['start'],
      end: json['end'],
    );
  }
}
