import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickLink extends StatelessWidget {
  final String title;
  final String url;
  final icon;
  const QuickLink({
    super.key,
    required this.title,
    required this.url,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Uri url = Uri.parse(this.url);
        launchUrl(url);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon is IconData
                  ? Icon(icon, size: 40, color: Colors.teal)
                  : icon,
              SizedBox(height: 8),
              Text(title, style: MyTextStyle(fontSize: 18, fontWeight: .bold)),
            ],
          ),
        ),
      ),
    );
  }
}
