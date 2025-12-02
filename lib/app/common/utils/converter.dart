import 'package:flutter/material.dart';

class Converter {
  static double timeOfDayToDouble(TimeOfDay time) {
    return time.hour + time.minute / 60.0;
  }

static String timeOfDayToBackend(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  final iso = dt.toUtc().toIso8601String();
  return iso; // <-- gunakan ISO lengkap
}


  static int hoursToMinutes(String hours) {
    final h = int.tryParse(hours) ?? 0;
    return h * 60;
  }
  static int calculateSleepDuration(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    if (endMinutes < startMinutes) {
      return (24 * 60 - startMinutes) + endMinutes;
    }

    return endMinutes - startMinutes;
  }
}
