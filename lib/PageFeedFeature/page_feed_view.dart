import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
import 'package:fcds_announcements/PageFeedFeature/Widgets/announcement.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';

class PageFeedView extends StatelessWidget {
  final CourseDataModel subject;
  final PageDataModel page;
  const PageFeedView({super.key, required this.subject, required this.page});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${subject.name} ${page.title}",
          style: MyTextStyle(fontSize: 20, fontWeight: .bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
          color: Color.fromARGB(255, 32, 223, 159),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Announcements',
                  style: MyTextStyle(fontSize: 24, fontWeight: .bold),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 230, 239, 236),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: .symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    '3 new',
                    style: MyTextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 82, 150, 127),
                      fontWeight: .w600,
                    ),
                  ),
                ),
              ],
            ),
            Announcement(),
          ],
        ),
      ),
    );
  }
}
