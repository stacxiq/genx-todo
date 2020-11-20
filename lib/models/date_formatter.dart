import 'package:intl/intl.dart';

class CustomDateFormatter {
  static String format(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (dateTime == null) return '';

    DateTime localDateTime = dateTime.toLocal();

    String roughTimeString = DateFormat('jm').format(dateTime);

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Today , $roughTimeString';
    }

    DateTime yesterday = now.add(Duration(days: 1));

    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Tomorrow, $roughTimeString';
    }

    return '${DateFormat.yMd().add_jm().format(dateTime)}';
  }
}
