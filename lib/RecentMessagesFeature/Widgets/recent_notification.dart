import 'package:fcds_announcements/RecentMessagesFeature/Data%20Models/notification_data_model.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:fcds_announcements/utils/Widgets/unread.dart';
import 'package:fcds_announcements/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class RecentNotification extends StatelessWidget {
  final NotificationItemDataModel? notification;
  final Color color;
  const RecentNotification({
    super.key,
    required this.notification,
    this.color = const Color.fromARGB(255, 54, 125, 101),
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Unread(
            isUnread: !(notification?.isRead ?? true),
            child: Container(
              decoration: BoxDecoration(
                color: color.computeLuminance() < 0.5
                    ? color.withValues(alpha: 0.2)
                    : color.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: .all(8),
              child: Icon(Icons.notifications, color: color),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    Text(
                      notification?.title ?? 'No Title',
                      style: MyTextStyle(fontSize: 16, fontWeight: .bold),
                    ),
                    Spacer(),
                    Text(
                      Dateformatter.getTimeAgo(
                        notification?.timestamp ?? DateTime.now(),
                      ),
                      style: MyTextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 135, 163, 153),
                        fontWeight: .w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  notification?.body ?? 'No Body',
                  style: MyTextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 135, 163, 153),
                    fontWeight: .w400,
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
