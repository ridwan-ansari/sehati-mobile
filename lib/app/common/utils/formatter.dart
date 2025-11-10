import 'package:intl/intl.dart';

class Formatter {
  static String currency(num value, {String symbol = 'Rp'}) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: symbol, decimalDigits: 0);
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
}
