// ignore_for_file: unnecessary_this

class ScheduleResponse {
  int? statusCode;
  String? message;
  List<ScheduleData>? data;

  ScheduleResponse({this.statusCode, this.message, this.data});

  ScheduleResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ScheduleData>[];
      json['data'].forEach((v) {
        data!.add(ScheduleData.fromJson(v));
      });
    }
  }
}

class ScheduleData {
  String? id;
  String? professionalId;
  String? scheduleDate;
  String? status;
  String? scheduleTime;
  String? notes;
  String? userId;
  String? createdAt;
  ProfessionalDetail? professional;

  ScheduleData({
    this.id,
    this.professionalId,
    this.scheduleDate,
    this.status,
    this.scheduleTime,
    this.notes,
    this.userId,
    this.createdAt,
    this.professional,
  });

  ScheduleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    professionalId = json['professional_id'];
    scheduleDate = json['appointment_date']; 
    status = json['status'];
    scheduleTime = json['appointment_time'];
    notes = json['notes'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    professional = json['professional'] != null
        ? ProfessionalDetail.fromJson(json['professional'])
        : null;
  }
}

class ProfessionalDetail {
  String? phoneNumber;
  String? fullname;
  String? bio;
  String? email;
  String? specialization;
  String? picture;

  ProfessionalDetail({
    this.phoneNumber,
    this.fullname,
    this.bio,
    this.email,
    this.specialization,
    this.picture,
  });

  ProfessionalDetail.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phone_number'];
    fullname = json['fullname'];
    bio = json['bio'];
    email = json['email'];
    specialization = json['specialization'];
    picture = json['picture'];
  }
}
