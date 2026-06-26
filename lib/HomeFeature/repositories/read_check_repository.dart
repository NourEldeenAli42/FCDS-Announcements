import 'package:fcds_announcements/RecentMessagesFeature/repositories/notification_reciever_repository.dart';

class ReadCheckRepository {
  final NotificationRepository _notificationRepository =
      NotificationRepository();

  Stream<bool> hasUnreadMessages() {
    final unreadMessages = _notificationRepository.watchUnreadMessages();
    return unreadMessages;
  }
}
