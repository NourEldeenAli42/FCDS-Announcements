import 'package:fcds_announcements/HomeFeature/Widgets/function_card.dart';
import 'package:fcds_announcements/HomeFeature/Widgets/priority_deadline.dart';
import 'package:fcds_announcements/HomeFeature/Widgets/urgent_announcement.dart';
import 'package:fcds_announcements/assets/assets_links.dart';
import 'package:fcds_announcements/utils/text_style.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: .all(8),
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Wednesday. Oct 24\n',
                style: MyTextStyle(fontSize: 14, color: Color(0xFF608579)),
              ),
              TextSpan(
                text: 'Good Morning, User!',
                style: MyTextStyle(
                  color: Color(0xFF111815),
                  fontSize: 24,
                  fontWeight: .bold,
                ),
              ),
            ],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          CircleAvatar(
            radius: 25,
            foregroundImage: AssetImage(profilePicture),
            backgroundColor: Colors.blueGrey,
          ),
        ],
      ),
      body: ListView(
        padding: .all(9),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Announcements will be displayed here.',
              style: MyTextStyle(fontSize: 18),
            ),
          ),
          UrgentAnnouncement(
            chipText: 'URGENT UPDATE',
            titleText: 'School closes early today',
            bodyText: 'All classes end at 1:00 PM due to weather conditions.',
            timeText: '2 hours',
          ),
          SizedBox(height: 20),
          PriorityDeadlineCard(
            title: 'Math Exam: Algebra II',
            timeLeft: '3 days',
          ),
          SizedBox(height: 20),
          Wrap(
            children: [
              FunctionCard(
                icon: Icons.book,
                label: 'Materials',
                color: Colors.blue,
              ),
              FunctionCard(
                icon: Icons.messenger_outline_sharp,
                label: 'Messages',
                color: Colors.purple,
              ),
              FunctionCard(
                icon: Icons.alarm,
                label: 'Set Alarm',
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
