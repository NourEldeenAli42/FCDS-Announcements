import 'package:fcds_announcements/PageFeedFeature/Data%20Models/announcement_data_model.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:fcds_announcements/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class Event extends StatelessWidget {
  final AnnouncementDataModel announcement;
  const Event({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: .symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: .all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.teal.withAlpha(150),
                  child: Icon(Icons.event, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    announcement.title,
                    style: MyTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),
            Text(
              announcement.content,
              style: MyTextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Text(
              Dateformatter.formatDate(announcement.date),
              style: MyTextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
