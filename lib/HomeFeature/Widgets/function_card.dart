import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:fcds_announcements/utils/Widgets/unread.dart';
import 'package:flutter/material.dart';

class FunctionCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool hasUnread;
  const FunctionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.hasUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: .circular(8),

      child: Container(
        decoration: BoxDecoration(
          color: color.withAlpha(100),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(51),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: .all(16),

        child: hasUnread
            ? Row(
                children: [
                  Unread(
                    isUnread: true,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: color.computeLuminance() < 0.5
                          ? color.withValues(alpha: 0.2)
                          : color.withValues(alpha: 0.6),
                      child: Icon(icon, size: 30, color: color),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    label,
                    style: MyTextStyle(fontSize: 18, fontWeight: .bold),
                  ),
                ],
              )
            : Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: color.computeLuminance() < 0.5
                        ? color.withValues(alpha: 0.2)
                        : color.withValues(alpha: 0.6),
                    child: Icon(icon, size: 30, color: color),
                  ),
                  SizedBox(width: 16),
                  Text(
                    label,
                    style: MyTextStyle(fontSize: 18, fontWeight: .bold),
                  ),
                ],
              ),
      ),
    );
  }
}
