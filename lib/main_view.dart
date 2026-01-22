import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:fcds_announcements/HomeFeature/home_view.dart';
import 'package:fcds_announcements/SubjectsFeature/subjects_view.dart';
import 'package:fcds_announcements/assets/assets_links.dart';
import 'package:fcds_announcements/utils/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final _pageViewController = PageController(initialPage: 1);
  @override
  dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  int _currentIndex = 1;
  Widget getCurrentPage(int index) {
    switch (index) {
      case 0:
        return HomeView();
      case 1:
        return SubjectsView();
      case 2:
        return Center(child: Text('Favorites'));
      case 3:
        return Center(child: Text('Search'));
      case 4:
        return Center(child: Text('Profile'));
      default:
        return HomeView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CrystalNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              if (index != _currentIndex) {
                if ((index - _currentIndex).abs() == 1) {
                  _pageViewController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  _pageViewController.jumpToPage(index);
                }
              }
            });
          },
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.black.withAlpha(80),
          borderWidth: 2,
          outlineBorderColor: Colors.white,
          items: [
            /// Home
            CrystalNavigationBarItem(
              icon: Icons.home,
              unselectedIcon: Icons.home,
              selectedColor: Colors.white,
            ),

            /// Add
            CrystalNavigationBarItem(
              icon: Icons.school,
              unselectedIcon: Icons.school,
              selectedColor: Color.fromARGB(255, 54, 125, 101),
            ),

            /// Favourite
            CrystalNavigationBarItem(
              icon: Icons.favorite,
              unselectedIcon: Icons.favorite_border,
              selectedColor: Colors.red,
            ),

            /// Search
            CrystalNavigationBarItem(
              icon: Icons.search,
              unselectedIcon: Icons.search,
              selectedColor: Colors.white,
            ),

            /// Profile
            CrystalNavigationBarItem(
              icon: Icons.person,
              unselectedIcon: Icons.person,
              selectedColor: Colors.white,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actionsPadding: .all(8),
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Wednesday. Oct 24\n',
                style: MyTextStyle(fontSize: 14, color: Color(0xFF608579)),
              ),
              TextSpan(
                text: 'Good Morning, User!',
                style: MyTextStyle(
                  color: Color(0xFF111815),
                  fontSize: 24,
                  fontWeight: .bold,
                ),
              ),
            ],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          InkWell(
            onTap: () => FirebaseAuth.instance.signOut(),
            child: CircleAvatar(
              radius: 25,
              foregroundImage: AssetImage(profilePicture),
              backgroundColor: Colors.blueGrey,
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageViewController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: List.generate(5, (index) => getCurrentPage(index)),
      ),
    );
  }
}
