import 'package:cached_network_image/cached_network_image.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:fcds_announcements/FollowPageFeature/search_courses.dart';
import 'package:fcds_announcements/HomeFeature/home_view.dart';
import 'package:fcds_announcements/LoginFeature/repositories/auth_repository.dart';
import 'package:fcds_announcements/RemindersFeature/bloc/reminders_bloc.dart';
import 'package:fcds_announcements/RemindersFeature/reminder_view.dart';
import 'package:fcds_announcements/SubjectsFeature/Widgets/add_reminder_form.dart';
import 'package:fcds_announcements/SubjectsFeature/subjects_view.dart';
import 'package:fcds_announcements/SubjectsFeature/bloc/Subjects%20Bloc/subjects_bloc.dart';
import 'package:fcds_announcements/generated/assets.dart';
import 'package:fcds_announcements/utils/date_formatter.dart';
import 'package:fcds_announcements/utils/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        return BlocProvider(
          create: (context) => SubjectsBloc()..add(const LoadSubjectsEvent()),
          child: SubjectsView(),
        );
      case 2:
        return Center(child: Text('Favorites'));
      case 3:
        return ReminderView();
      case 4:
        return Center(child: Text('Profile'));
      default:
        return HomeView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchCourses());
              },
              backgroundColor: Color.fromARGB(255, 54, 125, 101),
              child: Icon(Icons.add, color: Colors.white),
            )
          : _currentIndex == 3
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: Text(
                        'Schedule New Reminder',
                        style: MyTextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: BlocProvider.value(
                        value: context.read<RemindersBloc>(),
                        child: AddReminderForm(onReminderScreen: true),
                      ),
                    );
                  },
                );
              },
              backgroundColor: Color.fromARGB(255, 54, 125, 101),
              child: Icon(Icons.notification_add, color: Colors.white),
            )
          : null,
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
              icon: Icons.alarm,
              unselectedIcon: Icons.alarm,
              selectedColor: Color.fromARGB(255, 54, 125, 101),
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
        toolbarHeight: 80,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: Dateformatter().formatDate(DateTime.now()),
                style: MyTextStyle(fontSize: 14, color: Color(0xFF608579)),
              ),
              TextSpan(
                text: 'Good Morning, \n',
                style: MyTextStyle(
                  color: Color(0xFF111815),
                  fontSize: 20,
                  fontWeight: .bold,
                ),
              ),
              TextSpan(
                text: FirebaseAuth.instance.currentUser?.displayName ?? 'User',
                style: MyTextStyle(
                  color: Color(0xFF111815),
                  fontSize: 18,
                  fontWeight: .bold,
                ),
              ),
            ],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: Text(
                      'Logout',
                      style: MyTextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      'Are you sure you want to logout?\n All your reminders will be cleared from this device.',
                      style: MyTextStyle(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: MyTextStyle(color: Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await AuthRepository().signOut();
                          if (dialogContext.mounted) {
                            Navigator.of(dialogContext).pop();
                          }
                        },
                        child: Text(
                          'Logout',
                          style: MyTextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 2.5),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    child: CachedNetworkImage(
                      imageUrl:
                          FirebaseAuth.instance.currentUser?.photoURL ??
                          Assets.assetsLinks,
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 18,
                        backgroundImage: imageProvider,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.logout, color: Colors.white, size: 12),
                  ),
                ),
              ],
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
