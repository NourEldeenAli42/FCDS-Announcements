import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';

class PageWarning extends StatelessWidget {
  final String title;
  final String message;
  const PageWarning({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: MyTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 146, 96, 38),
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 199, 165, 70),
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
