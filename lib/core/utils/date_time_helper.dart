import 'package:intl/intl.dart';

class DateTimeHelper {
  static String getFormattedNow() {
    final now = DateTime.now();
    final formatter = DateFormat('dd-MM-yyyy HH:mm');
    return formatter.format(now);
  }
}