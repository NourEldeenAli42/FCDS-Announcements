String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  int hours = duration.inHours;

  if (hours > 0) {
    if (duration.inMinutes.remainder(60) > 0) {
      return "$hours hours $twoDigitMinutes minutes";
    } else {
      return "$hours hours";
    }
  } else if (duration.inMinutes > 0) {
    return "${duration.inMinutes} minutes";
  } else {
    return "NOW";
  }
}

class PriorityDeadlineDataModel {
  final String title;
  final String remainingTime;

  PriorityDeadlineDataModel({required this.title, required this.remainingTime});
  factory PriorityDeadlineDataModel.fromFirestore(Map<String, dynamic> data) {
    final timeText = formatDuration(
      data['deadline'].toDate().difference(DateTime.now()),
    );
    return PriorityDeadlineDataModel(
      title: data['title'] ?? '',
      remainingTime: timeText,
    );
  }
}
