import 'package:fcds_announcements/RemindersFeature/Data%20Models/reminder_data_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class RemindersRepository {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<List<Reminder>> getPendingReminders() async {
    List<Reminder> reminders = [];
    for (var noti
        in await flutterLocalNotificationsPlugin
            .pendingNotificationRequests()) {
      reminders.add(Reminder.fromMap(noti));
    }
    return reminders;
  }
  Future<void> removeReminder(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }
}
