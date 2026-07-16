import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';

class TotalAdminsCard extends StatelessWidget {
  final int? totalAdmins;
  const TotalAdminsCard({super.key, required this.totalAdmins});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: .fromLTRB(
          left: BorderSide(
            color: Colors.red,
            width: 5,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.admin_panel_settings, size: 30, color: Colors.red),
          SizedBox(height: 10),
          Text(
            'Current Admins',
            style: MyTextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            totalAdmins?.toString() ?? '...',
            style: MyTextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
