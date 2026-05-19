import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/data/models/response/professional_res_model.dart';

/// Stateless helpers for formatting a professional's weekly availability and
/// generating the bookable time slots for a given day.
class AppointmentScheduleFormatter {
  AppointmentScheduleFormatter._();

  static const int defaultSlotMinutes = 30;

  /// Localized full day name (Senin / Monday / ...) for use in the picker
  /// header, derived from a Dart [DateTime.weekday] value (1 = Monday).
  static String localizedDay(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return AppStrings.get(AppStrings.dayKeyMonday);
      case DateTime.tuesday:
        return AppStrings.get(AppStrings.dayKeyTuesday);
      case DateTime.wednesday:
        return AppStrings.get(AppStrings.dayKeyWednesday);
      case DateTime.thursday:
        return AppStrings.get(AppStrings.dayKeyThursday);
      case DateTime.friday:
        return AppStrings.get(AppStrings.dayKeyFriday);
      case DateTime.saturday:
        return AppStrings.get(AppStrings.dayKeySaturday);
      case DateTime.sunday:
        return AppStrings.get(AppStrings.dayKeySunday);
    }
    return '';
  }

  /// Generates 24h "HH:mm" slot labels stepping every [stepMinutes] within
  /// [window]. The end bound is exclusive so a 09:00–17:00 window with a
  /// 30-min step ends at 16:30.
  static List<String> generateSlots(
    DayHours window, {
    int stepMinutes = defaultSlotMinutes,
  }) {
    final start = _parseMinutes(window.start);
    final end = _parseMinutes(window.end);
    if (start == null || end == null || end <= start) return const [];

    final slots = <String>[];
    for (var m = start; m < end; m += stepMinutes) {
      slots.add(_formatMinutes(m));
    }
    return slots;
  }

  static int? _parseMinutes(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }

  static String _formatMinutes(int totalMinutes) {
    final h = (totalMinutes ~/ 60).toString().padLeft(2, '0');
    final m = (totalMinutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }
}
