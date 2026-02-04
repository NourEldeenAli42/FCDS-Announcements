import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Reminder {
  final int id;
  final String title;
  final String body;
  final DateTime scheduledDateTime;

  Reminder({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledDateTime,
  });
  factory Reminder.fromMap(PendingNotificationRequest map) {
    return Reminder(
      id: map.id,
      title: map.title ?? 'Unspecified Reminder Title',
      body: map.body ?? 'Unspecified Reminder Body',
      scheduledDateTime: DateTime.fromMillisecondsSinceEpoch(map.id * 1000),
    );
  }
}
