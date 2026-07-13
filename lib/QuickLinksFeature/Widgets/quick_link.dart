import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickLink extends StatelessWidget {
  final String title;
  final String url;
  // ignore: strict_top_level_inference, prefer_typing_uninitialized_variables
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
                  : icon is FaIconData
                  ? FaIcon(icon, size: 40, color: Colors.teal)
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
