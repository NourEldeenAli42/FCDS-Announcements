import 'package:fcds_announcements/utils/text_style.dart';
import 'package:flutter/material.dart';

class SubjectTile extends StatelessWidget {
  final Color color;
  final IconData icon = Icons.book;
  const SubjectTile({super.key, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: color.computeLuminance() < 0.5
              ? color.withValues(alpha: 0.2)
              : color.withValues(alpha: 0.6),
          child: Icon(icon, size: 28, color: color),
        ),
        collapsedShape: Border(),
        shape: Border(),
        title: Text(
          'Mathematics',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        children: [
          Container(
            margin: .all(10),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 30,
                  color: Colors.orange,
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    Text(
                      'Upcoming Exam',
                      style: MyTextStyle(
                        fontSize: 16,
                        fontWeight: .bold,
                        color: Color.fromARGB(255, 146, 96, 38),
                      ),
                    ),
                    Text(
                      'Date: 25th Dec 2024',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 199, 165, 70),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //TODO: Add more children widgets here as needed "Assigned Materials, Announcements, etc."
        ],
      ),
    );
  }
}
