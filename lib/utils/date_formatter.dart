final class Dateformatter {
  static String getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  static String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan ';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  static String formatDate(DateTime date) {
    String month = getMonthName(date.month);
    String weekday = getWeekdayName(date.weekday);
    return '$weekday, $month ${date.day}\n';
  }

  static String getTimeAgo(DateTime date) {
    String timeAgo;
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inSeconds < 60) {
      timeAgo = 'Just Now';
    } else if (diff.inMinutes < 60) {
      if (diff.inMinutes == 1) {
        timeAgo = '1 minute ago';
      } else {
        timeAgo = '${diff.inMinutes} minutes ago';
      }
      timeAgo = '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      timeAgo = '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      if (diff.inDays == 1) {
        timeAgo = '1 day ago';
      } else {
        timeAgo = '${diff.inDays} days ago';
      }
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      timeAgo = '$weeks weeks ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      timeAgo = '$months months ago';
    } else {
      final years = (diff.inDays / 365).floor();
      timeAgo = '$years years ago';
    }
    return timeAgo;
  }
}
