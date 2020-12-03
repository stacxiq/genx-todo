import 'package:intl/intl.dart';

class CustomDateFormatter {
  static String format(DateTime dateTime) {
    final now = DateTime.now();
    if (dateTime == null) return '';

    final localDateTime = dateTime.toLocal();

    final roughTimeString = DateFormat('jm').format(dateTime);

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Today , $roughTimeString';
    }

    final yesterday = now.add(const Duration(days: 1));

    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Tomorrow, $roughTimeString';
    }

    return '${DateFormat.yMd().add_jm().format(dateTime)}';
  }
}
