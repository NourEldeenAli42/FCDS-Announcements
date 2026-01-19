import 'package:fcds_announcements/utils/text_style.dart';
import 'package:flutter/material.dart';

class FunctionCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  const FunctionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        borderRadius: .circular(10),
        splashColor: color.withAlpha(30),
        onTap: () {
          // Handle card tap
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.computeLuminance() < 0.5
                    ? color.withValues(alpha: 0.2)
                    : color.withValues(alpha: 0.6),
                child: Icon(icon, size: 30, color: color),
              ),
              SizedBox(height: 10),
              Text(label, style: MyTextStyle(fontSize: 18, fontWeight: .bold)),
            ],
          ),
        ),
      ),
    );
  }
}
