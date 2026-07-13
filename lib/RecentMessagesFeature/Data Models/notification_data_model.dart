// This line is needed for code generation
import 'package:isar_community/isar.dart';

part 'notification_data_model.g.dart';

@collection
class NotificationItemDataModel {
  Id id = Isar.autoIncrement; // Local ID

  @Index()
  String? messageId; // FCM Message ID

  String? title;
  String? body;

  @Index()
  DateTime timestamp = DateTime.now();

  bool isRead = false;
}
