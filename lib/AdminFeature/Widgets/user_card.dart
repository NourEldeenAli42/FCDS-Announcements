import 'package:fcds_announcements/AdminFeature/Data%20Models/user_data_model.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final UserDataModel userData;
  final VoidCallback? onClick;
  const UserCard({super.key, required this.userData, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: userData.isAdmin ? Colors.red[50] : Colors.white,
      child: Padding(
        padding: const .all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: userData.isAdmin ? Colors.red[100] : null,
              child: Icon(
                Icons.person,
                size: 30,
                color: userData.isAdmin ? Colors.red : null,
              ),
            ),
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
                Chip(
                  shape: StadiumBorder(),
                  label: Text(
                    userData.isAdmin ? 'Admin' : 'Student',
                    style: MyTextStyle(
                      color: userData.isAdmin ? Colors.red : Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: userData.isAdmin
                      ? Colors.red[100]
                      : Colors.grey[300],
                ),
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: onClick,
              icon: Icon(
                userData.isAdmin ? Icons.remove_circle : Icons.add_circle,
                color: userData.isAdmin ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
