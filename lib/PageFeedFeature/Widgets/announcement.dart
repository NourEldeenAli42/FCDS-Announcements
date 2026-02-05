import 'package:fcds_announcements/PageFeedFeature/Data%20Models/announcement_data_model.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:fcds_announcements/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Announcement extends StatelessWidget {
  final AnnouncementDataModel announcement;
  const Announcement({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: .symmetric(vertical: 16, horizontal: 16),
      child: Padding(
        padding: const .symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Text(
                  Dateformatter.getTimeAgo(announcement.date),
                  style: MyTextStyle(
                    color: const Color.fromARGB(255, 80, 149, 126),
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.circle,
                  color: const Color.fromARGB(255, 32, 223, 159),
                  size: 12,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              announcement.title,
              style: MyTextStyle(fontSize: 24, fontWeight: .bold),
            ),
            const SizedBox(height: 8),
            Text(
              announcement.content,
              style: MyTextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 82, 102, 93),
              ),
            ),

            const SizedBox(height: 12),
            if (announcement.redirectUrl.isNotEmpty)
              OutlinedButton(
                onPressed: () {
                  final Uri url = Uri.parse(announcement.redirectUrl);
                  launchUrl(url);
                },
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    announcement.redirectUrl.contains('drive')
                        ? Icon(Icons.add_to_drive)
                        : announcement.redirectUrl.contains('chameleon')
                        ? Image.asset(
                            'assets/chameleon.webp',
                            color: Color.fromARGB(255, 40, 127, 111),
                            width: 35,
                          )
                        : SizedBox(width: 8),
                    Text('View Attachment'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
