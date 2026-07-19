import 'package:cached_network_image/cached_network_image.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:fcds_announcements/ChatFeature/chat_view.dart';
import 'package:fcds_announcements/FollowPageFeature/search_courses.dart';
import 'package:fcds_announcements/HomeFeature/home_view.dart';
import 'package:fcds_announcements/QuickLinksFeature/quick_links_view.dart';
import 'package:fcds_announcements/RemindersFeature/bloc/Reminders%20Bloc/reminders_bloc.dart';
import 'package:fcds_announcements/RemindersFeature/reminder_view.dart';
import 'package:fcds_announcements/SubjectsFeature/Widgets/add_reminder_form.dart';
import 'package:fcds_announcements/SubjectsFeature/subjects_view.dart';
import 'package:fcds_announcements/SubjectsFeature/bloc/Subjects%20Bloc/subjects_bloc.dart';
import 'package:fcds_announcements/generated/assets.dart';
import 'package:fcds_announcements/utils/date_formatter.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final _pageViewController = PageController();

  String? _avatarUrlFromMetadata(Object? avatarUrl) {
    if (avatarUrl is! String) return null;

    final match = RegExp(r'https?://[^\s\]\)]+').firstMatch(avatarUrl);
    return match?.group(0);
  }

  @override
  dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  int _currentIndex = 0;

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
        return ReminderView();
      case 3:
        return QuickLinksView();
      default:
        return HomeView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchCourses());
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : _currentIndex == 2
          ? FloatingActionButton(
              onPressed: () async {
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
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.notification_add,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatView()),
                );
              },
              child: Icon(Icons.add),
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

            /// Subjects
            CrystalNavigationBarItem(
              icon: Icons.school,
              unselectedIcon: Icons.school,
              selectedColor: Colors.amberAccent,
            ),

            /// Reminders
            CrystalNavigationBarItem(
              icon: Icons.alarm,
              unselectedIcon: Icons.alarm,
              selectedColor: Theme.of(context).colorScheme.primary,
            ),

            /// Links
            CrystalNavigationBarItem(
              icon: Icons.link,
              unselectedIcon: Icons.link,
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
                text: Dateformatter.formatDate(DateTime.now()),
                style: MyTextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              TextSpan(
                text: 'Good ${Dateformatter.getDayTime(DateTime.now())}, \n',
                style: MyTextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                //TODO: Fetch the user's name from Supabase DATABASE and display it here
                text:
                    Supabase
                        .instance
                        .client
                        .auth
                        .currentUser
                        ?.userMetadata?['full_name'] ??
                    'User',
                style: MyTextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: Builder(
              builder: (context) {
                final avatarUrl = _avatarUrlFromMetadata(
                  Supabase
                      .instance
                      .client
                      .auth
                      .currentUser
                      ?.userMetadata?['avatar_url'],
                );

                final avatar = avatarUrl == null
                    ? CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage(Assets.profile),
                      )
                    : CachedNetworkImage(
                        imageUrl: avatarUrl,
                        placeholder: (context, url) => CircleAvatar(
                          radius: 18,
                          backgroundImage: AssetImage(Assets.profile),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 18,
                          backgroundImage: AssetImage(Assets.profile),
                        ),
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 18,
                          backgroundImage: imageProvider,
                        ),
                      );

                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.5,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: avatar,
                  ),
                );
              },
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
        children: List.generate(4, (index) => getCurrentPage(index)),
      ),
    );
  }
}
