import 'package:fcds_announcements/AdminFeature/Data%20Models/user_data_model.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';

class UserPermissionCard extends StatelessWidget {
  final UserDataModel userData;
  final VoidCallback? onClick;
  const UserPermissionCard({super.key, required this.userData, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const .all(8.0),
        child: Row(
          children: [
            CircleAvatar(radius: 20, child: Icon(Icons.person, size: 30)),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData.name,
                  style: MyTextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  userData.email,
                  style: MyTextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: onClick,
              icon: Icon(Icons.edit, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
