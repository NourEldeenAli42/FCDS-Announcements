import 'package:fcds_announcements/RecentMessagesFeature/Data%20Models/notification_data_model.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:fcds_announcements/utils/Widgets/unread.dart';
import 'package:fcds_announcements/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class RecentNotification extends StatelessWidget {
  final NotificationItemDataModel? notification;
  final Color? color;
  const RecentNotification({
    super.key,
    required this.notification,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Unread(
            isUnread: !(notification?.isRead ?? true),
            child: Container(
              decoration: BoxDecoration(
                color: activeColor.computeLuminance() < 0.5
                    ? activeColor.withValues(alpha: 0.2)
                    : activeColor.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.notifications, color: activeColor),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification?.title ?? 'No Title',
                        style: MyTextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      Dateformatter.getTimeAgo(
                        notification?.timestamp ?? DateTime.now(),
                      ),
                      style: MyTextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification?.body ?? 'No Body',
                  style: MyTextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
