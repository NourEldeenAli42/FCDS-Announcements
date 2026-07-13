import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';

class PageChip extends StatelessWidget {
  final String tag;
  const PageChip({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 6, top: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: Colors.blueGrey.shade800),
          SizedBox(width: 4),
          Text(
            tag,
            style: MyTextStyle(fontSize: 12, color: Colors.blueGrey.shade800),
          ),
        ],
      ),
    );
  }
}
