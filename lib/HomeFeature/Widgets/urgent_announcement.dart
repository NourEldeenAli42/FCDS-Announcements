import 'package:fcds_announcements/utils/text_style.dart';
import 'package:flutter/material.dart';

class UrgentAnnouncement extends StatelessWidget {
  String chipText;
  String titleText;
  String bodyText;
  String timeText;
  UrgentAnnouncement({
    super.key,
    required this.chipText,
    required this.titleText,
    required this.bodyText,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 54, 125, 101),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: .all(32),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Chip(
                label: Text(chipText, style: MyTextStyle(color: Colors.white)),
                backgroundColor: Color(0xEE5e9784),
                shape: StadiumBorder(),
                side: BorderSide(color: Colors.transparent),
              ),
              Icon(Icons.campaign, color: Colors.white),
            ],
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$titleText\n',
                  style: MyTextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: .bold,
                  ),
                ),
                TextSpan(
                  text: bodyText,
                  style: MyTextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              Icon(Icons.access_time, color: Colors.white70, size: 16),
              SizedBox(width: 4),
              Text(
                'Posted $timeText ago',
                style: MyTextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
