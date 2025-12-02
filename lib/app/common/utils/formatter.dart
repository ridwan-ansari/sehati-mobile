import 'package:intl/intl.dart';

class Formatter {
  static String currency(num value, {String symbol = 'Rp'}) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: symbol,
      decimalDigits: 0,
    );
    return format.format(value);
  }

  static String date(DateTime date) {
    final formatter = DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }

  static String time(DateTime date) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(date);
  }

  static String compactNumber(num value) {
    if (value < 1000) {
      return value.toString();
    } else if (value < 1000000) {
      return "${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K";
    } else if (value < 1000000000) {
      return "${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 1)}M";
    } else {
      return "${(value / 1000000000).toStringAsFixed(value % 1000000000 == 0 ? 0 : 1)}B";
    }
  }
}
