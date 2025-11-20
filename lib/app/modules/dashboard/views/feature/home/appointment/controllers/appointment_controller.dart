// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AppointmentController extends GetxController {
  // Reactive variables
  final selectedDate = ''.obs;
  final selectedTime = ''.obs;
  final meetInOffice = false.obs;
  final meetByZoom = false.obs;

  // Google Sign-In setup
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/calendar',
      'https://www.googleapis.com/auth/calendar.events',
    ],
    // 🔥 Ganti dengan client ID Android kamu
    serverClientId:
        '993039135325-130rqo6u11jprun9mt9gq9lnv21vhsiu.apps.googleusercontent.com',
  );

  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  // ==============================
  // Sign In Google
  // ==============================
  Future<void> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return;
      }

      _user = account;
      final auth = await account.authentication;

      // Setelah login sukses, langsung buat event ke Google Calendar
      await _createCalendarEvent(auth.accessToken);
    } catch (_) {}
  }

  // ==============================
  // Create Event di Google Calendar
  // ==============================
  Future<void> _createCalendarEvent(String? accessToken) async {
    if (accessToken == null) return;

    final dateNow = selectedDate.value;
    final timeNow = selectedTime.value;


    if (dateNow.isEmpty || timeNow.isEmpty) {
      return;
    }

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

      final response = await http.post(
        Uri.parse(
          "https://www.googleapis.com/calendar/v3/calendars/primary/events",
        ),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode(event),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
      } else {}
    } catch (_) {}
  }

  // ==============================
  // Toggle Meeting Type
  // ==============================
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
