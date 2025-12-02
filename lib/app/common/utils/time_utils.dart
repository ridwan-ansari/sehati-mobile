// 📁 File: lib/app/common/utils/time_utils.dart
import 'package:intl/intl.dart';

/// Utility class untuk memformat waktu dan tanggal dengan mudah.
///
/// Pastikan sudah menambahkan dependency berikut di pubspec.yaml:
/// dependencies:
///   intl: ^0.19.0
///
/// Contoh penggunaan:
/// ```dart
/// TimeUtils.formatTime(DateTime.now());
/// TimeUtils.formatDate(DateTime.now(), format: 'dd MMM yyyy');
/// TimeUtils.formatDuration(Duration(hours: 2, minutes: 30));
/// ```

class TimeUtils {
  /// Format waktu (jam dan menit) seperti: 14:35
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Format tanggal standar seperti: 03 Nov 2025
  static String formatDate(DateTime dateTime, {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(dateTime);
  }

  /// Format tanggal lengkap seperti: Senin, 3 November 2025
  static String formatFullDate(DateTime dateTime) {
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(dateTime);
  }

  /// Format tanggal dan waktu seperti: 03 Nov 2025 - 14:35
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy - HH:mm').format(dateTime);
  }

  /// Format durasi ke bentuk jam dan menit seperti: 2 jam 30 menit
  static String formatDuration(Duration duration) {
    if (duration.inMinutes < 60) {
      return "${duration.inMinutes} menit";
    } else {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return "$hours jam${minutes > 0 ? ' $minutes menit' : ''}";
    }
  }

  /// Format waktu ke format 12 jam: 2:35 PM
  static String formatTime12Hour(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  /// Format tanggal pendek seperti: 03/11/2025
  static String formatShortDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  /// Format tanggal pendek seperti: 03/11
  static String formatDayMonth(DateTime dateTime) {
    return DateFormat('dd/MM').format(dateTime);
  }

  /// Format hanya bulan dan tahun seperti: November 2025
  static String formatMonthYear(DateTime dateTime) {
    return DateFormat('MMMM yyyy', 'id_ID').format(dateTime);
  }

  /// Format hari saja seperti: Senin
  static String formatDayName(DateTime dateTime) {
    return DateFormat('EEEE', 'id_ID').format(dateTime);
  }

  /// Hitung selisih waktu dalam format human readable, misalnya:
  /// "5 menit lalu", "2 jam lalu", "Kemarin", atau "3 hari lalu".
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) {
      return 'Baru saja';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    } else if (diff.inDays == 1) {
      return 'Kemarin';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    } else {
      return DateFormat('dd MMM yyyy').format(dateTime);
    }
  }

  /// Format tanggal untuk chart food diary
  /// Contoh: 05 Jan • 08:30
  static String formatChartDate(DateTime dateTime) {
    return DateFormat('dd MMM • HH:mm').format(dateTime);
  }

  /// Format chart versi pendek
  /// Contoh: 05/01 • 08:30
  static String formatChartDateShort(DateTime dateTime) {
    return DateFormat('dd MMM • HH:mm').format(dateTime);
  }

  /// Format jika hanya ingin jam saja
  /// Contoh: 08:30
  static String formatChartTimeOnly(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Ubah string waktu ke DateTime berdasarkan format tertentu
  static DateTime parseDate(String dateStr, {String format = 'dd/MM/yyyy'}) {
    return DateFormat(format).parse(dateStr);
  }

  /// Dapatkan waktu sekarang dalam format tertentu
  static String now({String format = 'dd MMM yyyy - HH:mm'}) {
    return DateFormat(format).format(DateTime.now());
  }
}
