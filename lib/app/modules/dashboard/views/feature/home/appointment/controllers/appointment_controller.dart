// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/models/response/professional_res_model.dart';
import 'package:sehati/app/data/services/professional_service.dart';

class AppointmentController extends GetxController {
  final professionalService = ProfessionalService();

  // Reactive variables
  final selectedDate = ''.obs;
  final selectedTime = ''.obs;
  final meetInOffice = false.obs;
  final meetByZoom = false.obs;

  var profeeesionalList = <ProfessionalData>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfessionals();
  }

  void loadProfessionals() async {
    isLoading.value = true;
    final result = await professionalService.getProfessionals();
    if (result != null) {
      profeeesionalList.assignAll(result);
    }
    isLoading.value = false;
  }

  void resetSelection() {
    selectedDate.value = '';
    selectedTime.value = '';
    meetInOffice.value = false;
    meetByZoom.value = false;
  }

  /// =====================================
  ///  GROUP DATA BY SPECIALIZATION
  /// =====================================
  Map<String, List<ProfessionalData>> get groupedBySpecialization {
    final map = <String, List<ProfessionalData>>{};

    for (final item in profeeesionalList) {
      final key = item.specialization ?? "Unknown";

      if (!map.containsKey(key)) {
        map[key] = [];
      }

      map[key]!.add(item);
    }

    return map;
  }

  // Google Sign-In setup
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/calendar',
      'https://www.googleapis.com/auth/calendar.events',
    ],
    serverClientId:
        '993039135325-130rqo6u11jprun9mt9gq9lnv21vhsiu.apps.googleusercontent.com',
  );

  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  Future<void> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return;

      _user = account;
      final auth = await account.authentication;

      await _createCalendarEvent(auth.accessToken);
    } catch (_) {}
  }

  Future<void> _createCalendarEvent(String? accessToken) async {
    if (accessToken == null) return;

    final dateNow = selectedDate.value;
    final timeNow = selectedTime.value;

    if (dateNow.isEmpty || timeNow.isEmpty) return;

    try {
      final now = DateTime.now();
      final eventStart = DateTime(
        now.year,
        now.month,
        now.day,
        TimeOfDay.now().hour,
        TimeOfDay.now().minute,
      );

      final event = {
        "summary": "Appointment with Dietisien",
        "description": "Meeting scheduled via app",
        "start": {
          "dateTime": eventStart.toUtc().toIso8601String(),
          "timeZone": "Asia/Jakarta",
        },
        "end": {
          "dateTime": eventStart
              .add(const Duration(hours: 1))
              .toUtc()
              .toIso8601String(),
          "timeZone": "Asia/Jakarta",
        },
      };

      await http.post(
        Uri.parse(
          "https://www.googleapis.com/calendar/v3/calendars/primary/events",
        ),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode(event),
      );
    } catch (_) {}
  }

  /// =====================================
  /// SUBMIT APPOINTMENT TO API BACKEND
  /// =====================================
  Future<void> submitAppointment({required String professionalId}) async {
    if (professionalId.isEmpty) {
      SnackbarUtils.show("Professional not selected");
      return;
    }

    if (!isValid) {
      SnackbarUtils.show("Please complete all appointment details");
      return;
    }

    final success = await professionalService.createAppointment(
      professionalId: professionalId,
      appointmentDate: selectedDate.value,
      appointmentTime: selectedTime.value,
      notes: meetInOffice.value ? "Meet in office" : "Meet via zoom",
    );

    if (success) {
      Get.back();
    }
  }

  void toggleMeetInOffice(bool value) {
    meetInOffice.value = value;
    if (value) meetByZoom.value = false;
  }

  void toggleMeetByZoom(bool value) {
    meetByZoom.value = value;
    if (value) meetInOffice.value = false;
  }

  bool get isValid =>
      selectedDate.isNotEmpty &&
      selectedTime.isNotEmpty &&
      (meetInOffice.value || meetByZoom.value);
}
