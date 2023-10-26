import 'package:intl/intl.dart';

String formatDateTimeToCustomFormat(DateTime dateTime) {
  final day = DateFormat('d').format(dateTime);
  final suffix = getDaySuffix(int.parse(day)).toString();
  final monthYear = DateFormat('MMM y').format(dateTime);

  return '$day$suffix $monthYear';
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

String standardizeViewCount(int viewCount) {
  if (viewCount < 1000) {
    return viewCount.toString();
  } else if (viewCount < 1000000) {
    double result = viewCount / 1000;
    return '${result.toStringAsFixed(1)} K';
  } else if (viewCount < 1000000000) {
    double result = viewCount / 1000000;
    return '${result.toStringAsFixed(1)} M';
  } else {
    double result = viewCount / 1000000000;
    return '${result.toStringAsFixed(1)} B';
  }
}

String formatDuration(Duration duration) {
  String hours = (duration.inHours % 24).toString().padLeft(2, '0');
  String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
  String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

  if (duration.inHours > 0) {
    return '$hours:$minutes:$seconds';
  } else {
    return '$minutes:$seconds';
  }
}
