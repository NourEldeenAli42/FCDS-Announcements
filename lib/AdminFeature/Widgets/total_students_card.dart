import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';

class TotalStudentsCard extends StatelessWidget {
  final int? totalStudents;
  const TotalStudentsCard({super.key, required this.totalStudents});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.group, size: 30, color: Colors.white),
          SizedBox(height: 10),
          Text(
            'Total Students',
            style: MyTextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            totalStudents?.toString() ?? '...',
            style: MyTextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
