import 'package:fcds_announcements/utils/date_formatter.dart';

class PriorityDeadlineDataModel {
  final String title;
  final String remainingTime;

  PriorityDeadlineDataModel({required this.title, required this.remainingTime});
  factory PriorityDeadlineDataModel.fromFirestore(Map<String, dynamic> data) {
    final timeText = Dateformatter.formatDuration(
      data['deadline'].toDate().difference(DateTime.now()),
    );
    return PriorityDeadlineDataModel(
      title: data['title'] ?? '',
      remainingTime: timeText,
    );
  }
}
