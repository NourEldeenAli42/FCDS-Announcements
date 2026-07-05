import 'package:fcds_announcements/HomeFeature/Widgets/function_card.dart';
import 'package:fcds_announcements/OnBoardingFeature/host_screen.dart';
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
              color: Color.fromARGB(255, 54, 125, 101),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HostScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
