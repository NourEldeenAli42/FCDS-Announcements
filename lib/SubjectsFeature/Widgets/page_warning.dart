import 'package:fcds_announcements/utils/text_style.dart';
import 'package:flutter/material.dart';

class PageWarning extends StatelessWidget {
  const PageWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Icon(Icons.warning_amber_rounded, size: 30, color: Colors.orange),
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
    );
  }
}
