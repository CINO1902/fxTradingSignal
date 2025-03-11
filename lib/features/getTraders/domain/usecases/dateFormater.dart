import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  String daySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String formattedDate = DateFormat("MMM d, yyyy HH:mm").format(dateTime);
  String day = DateFormat("d").format(dateTime);
  return formattedDate.replaceFirst(
      RegExp(r'\d+,'), '$day${daySuffix(int.parse(day))},');
}
