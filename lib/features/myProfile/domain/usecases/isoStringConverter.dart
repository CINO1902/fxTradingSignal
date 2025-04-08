String formatDateFromISO(String isoString) {
  final date = DateTime.parse(isoString);
  final day = date.day;
  final suffix = getDaySuffix(day);
  final month = months[date.month - 1];
  final year = date.year;

  return '$month $day$suffix $year';
}

String getDaySuffix(int day) {
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

const List<String> months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];
