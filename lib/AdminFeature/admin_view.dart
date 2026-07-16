import 'package:fcds_announcements/HomeFeature/Widgets/function_card.dart';
import 'package:flutter/material.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Panel')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            FunctionCard(
              icon: Icons.verified_user,
              label: 'Manage Users',
              color: Theme.of(context).colorScheme.primary,
              onTap: () {
                Navigator.pushNamed(context, '/users');
              },
            ),
            SizedBox(height: 10),
            FunctionCard(
              icon: Icons.announcement,
              label: 'Manage Permissions',
              color: Colors.indigo,
              onTap: () {
                Navigator.pushNamed(context, '/permissions');
              },
            ),
            SizedBox(height: 10),
            FunctionCard(
              icon: Icons.book,
              label: 'Manage Courses',
              color: Colors.orange,
              onTap: () {
                Navigator.pushNamed(context, '/manage_courses');
              },
            ),
            SizedBox(height: 10),
            FunctionCard(
              icon: Icons.subject,
              label: 'Manage Pages',
              color: Colors.purple,
              onTap: () {
                Navigator.pushNamed(context, '/manage_subjects');
              },
            ),
          ],
        ),
      ),
    );
  }
}
