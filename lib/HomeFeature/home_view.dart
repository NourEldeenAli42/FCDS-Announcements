import 'package:fcds_announcements/HomeFeature/Widgets/function_card.dart';
import 'package:fcds_announcements/HomeFeature/Widgets/priority_deadline.dart';
import 'package:fcds_announcements/HomeFeature/Widgets/urgent_announcement.dart';
import 'package:fcds_announcements/HomeFeature/bloc/Announcement%20Bloc/announcement_bloc.dart';
import 'package:fcds_announcements/HomeFeature/repositories/urgent_update_reposittory.dart';
import 'package:fcds_announcements/assets/assets_links.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:fcds_announcements/utils/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => UrgentAnnouncementRepository(),
      child: RepositoryProvider(
        create: (context) => UserRepository(),
        child: BlocProvider(
          create: (context) => AnnouncementBloc()..add(LoadAnnouncementEvent()),
          child: Scaffold(
            appBar: AppBar(
              actionsPadding: .all(8),
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Wednesday. Oct 24\n',
                      style: MyTextStyle(
                        fontSize: 14,
                        color: Color(0xFF608579),
                      ),
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
            body: _HomeViewBody(),
          ),
        ),
      ),
    );
  }
}

class _HomeViewBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AnnouncementBloc>().add(RefreshAnnouncementEvent());
      },
      child: ListView(
        padding: .all(9),
        children: [
          BlocBuilder<AnnouncementBloc, AnnouncementState>(
            builder: (context, state) {
              if (state is AnnouncementLoading) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: .all(16),
                      width: double.infinity,
                      height: 100,
                      color: Colors.white,
                    ),
                  ),
                );
              } else if (state is AnnouncementLoaded) {
                final announcement = state.announcement;
                if (announcement != null) {
                  return Container(
                    margin: .only(bottom: 16),
                    child: UrgentAnnouncement(
                      chipText: 'URGENT UPDATE',
                      titleText: announcement.titleText,
                      bodyText: announcement.bodyText,
                      timeText: '2 hours ago',
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox.shrink(),
                  );
                }
              }
              return SizedBox.shrink();
            },
          ),
          PriorityDeadlineCard(
            title: 'Math Exam: Algebra II',
            timeLeft: '3 days',
          ),
          SizedBox(height: 20),
          Wrap(
            children: [
              FunctionCard(
                icon: Icons.book,
                label: 'Materials',
                color: Colors.blue,
              ),
              FunctionCard(
                icon: Icons.messenger_outline_sharp,
                label: 'Messages',
                color: Colors.purple,
              ),
              FunctionCard(
                icon: Icons.alarm,
                label: 'Set Alarm',
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
