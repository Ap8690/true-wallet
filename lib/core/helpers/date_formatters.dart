import 'package:intl/intl.dart'; // Ensure the intl package is added in pubspec.yaml

class DateFormatters {
  String formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      // Instead of showing 'X minutes ago', show the actual time in 'h:mm a' format
      return DateFormat('h:mm a').format(dateTime);
    } else if (difference.inHours < 24) {
      // For messages sent today, display the actual time
      return DateFormat('h:mm a').format(dateTime);
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return _getWeekDay(dateTime);
    } else {
      return _formatDate(dateTime);
    }
  }

  String _getWeekDay(DateTime dateTime) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[dateTime.weekday - 1];
  }

  String _formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    return '$day/$month/$year';
  }
}
