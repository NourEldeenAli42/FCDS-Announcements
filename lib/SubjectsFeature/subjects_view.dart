import 'package:fcds_announcements/SubjectsFeature/Widgets/subject_tile.dart';
import 'package:fcds_announcements/utils/text_style.dart';
import 'package:flutter/material.dart';

class SubjectsView extends StatelessWidget {
  const SubjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const .all(8.0),
        child: ListView(
          children: [
            Text(
              'My Subjects',
              style: MyTextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            Text(
              'Manage your enrollment and stay updated.',
              style: MyTextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            SubjectTile(),
          ],
        ),
      ),
    );
  }
}
