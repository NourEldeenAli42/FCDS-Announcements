import 'package:fcds_announcements/RecentMessagesFeature/Data%20Models/notification_data_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 1. Initialize Firebase (required for background tasks)
  await Firebase.initializeApp();

  // 3. Save the data
  await NotificationRepository.saveNotification(message);
}

class NotificationRepository {
  static Isar? _isar;

  static Future<void> saveNotification(RemoteMessage message) async {
    // 1. Initialize Isar if it's not open
    if (_isar == null || !_isar!.isOpen) {
      // You must provide the path in background isolates
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([
        NotificationItemDataModelSchema,
      ], directory: dir.path);
    }

    // 2. Map RemoteMessage to our Model
    final newItem = NotificationItemDataModel()
      ..messageId = message.messageId
      ..title = message.data['title'] ?? message.notification?.title
      ..body = message.data['body'] ?? message.notification?.body
      ..timestamp = DateTime.now();

    // 3. Perform a synchronous write (fastest for background)
    await _isar!.writeTxn(() async {
      await _isar!.notificationItemDataModels.put(newItem);
    });
  }

  Future<List<NotificationItemDataModel>> getAllNotifications() async {
    if (_isar == null || !_isar!.isOpen) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([
        NotificationItemDataModelSchema,
      ], directory: dir.path);
    }

    return await _isar!.notificationItemDataModels
        .where()
        .sortByTimestampDesc()
        .findAll();
  }

  Stream<List<NotificationItemDataModel>> watchAllNotifications() async* {
    if (_isar == null || !_isar!.isOpen) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([
        NotificationItemDataModelSchema,
      ], directory: dir.path);
    }

    yield* _isar!.notificationItemDataModels
        .where()
        .sortByTimestampDesc()
        .watch(fireImmediately: true);
  }

  Future<void> markAllAsRead() async {
    if (_isar == null || !_isar!.isOpen) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([
        NotificationItemDataModelSchema,
      ], directory: dir.path);
    }

    await _isar!.writeTxn(() async {
      final allNotifications = await _isar!.notificationItemDataModels
          .where()
          .findAll();
      for (var notification in allNotifications) {
        notification.isRead = true;
        await _isar!.notificationItemDataModels.put(notification);
      }
    });
  }

  Stream<bool> watchUnreadMessages() async* {
    if (_isar == null || !_isar!.isOpen) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([
        NotificationItemDataModelSchema,
      ], directory: dir.path);
    }

    yield* _isar!.notificationItemDataModels
        .filter()
        .isReadEqualTo(false)
        .watch(fireImmediately: true)
        .map((notifications) => notifications.isNotEmpty);
  }

  Future<bool> markSpecificasRead(int id) async {
    if (_isar == null || !_isar!.isOpen) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([
        NotificationItemDataModelSchema,
      ], directory: dir.path);
    }

    final notification = await _isar!.notificationItemDataModels.get(id);
    if (notification != null) {
      await _isar!.writeTxn(() async {
        notification.isRead = true;
        await _isar!.notificationItemDataModels.put(notification);
      });
      return true; // Successfully marked as read
    }
    return false; // Notification with given id not found
  }

  Future<bool> deleteMessage(int id) async {
    if (_isar == null || !_isar!.isOpen) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([
        NotificationItemDataModelSchema,
      ], directory: dir.path);
    }

    final success = await _isar!.writeTxn(() async {
      return await _isar!.notificationItemDataModels.delete(id);
    });
    return success; // Returns true if deletion was successful
  }

  Future<void> deleteAllMessages() async {
    if (_isar == null || !_isar!.isOpen) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([
        NotificationItemDataModelSchema,
      ], directory: dir.path);
    }

    await _isar!.writeTxn(() async {
      await _isar!.notificationItemDataModels.clear();
    });
  }
}
