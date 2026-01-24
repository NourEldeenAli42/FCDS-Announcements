import 'package:fcds_announcements/HomeFeature/Widgets/function_card.dart';
import 'package:fcds_announcements/HomeFeature/Widgets/priority_deadline.dart';
import 'package:fcds_announcements/HomeFeature/Widgets/urgent_announcement.dart';
import 'package:fcds_announcements/HomeFeature/bloc/Announcement%20Bloc/announcement_bloc.dart';
import 'package:fcds_announcements/HomeFeature/bloc/Priority%20Deadline%20Bloc/priority_deadline_bloc.dart';
import 'package:fcds_announcements/HomeFeature/repositories/priority_deadline_repository.dart';
import 'package:fcds_announcements/HomeFeature/repositories/urgent_update_repository.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PriorityDeadlineBloc()..add(LoadPriorityDeadlineEvent()),
      child: BlocProvider(
        create: (context) => AnnouncementBloc()..add(LoadAnnouncementEvent()),
        child: RepositoryProvider(
          create: (context) => PriorityDeadlineRepository(),
          child: RepositoryProvider(
            create: (context) => UrgentAnnouncementRepository(),
            child: RepositoryProvider(
              create: (context) => UserRepository(),
              child: Builder(
                builder: (context) => RefreshIndicator(
                  onRefresh: () async {
                    context.read<AnnouncementBloc>().add(
                      RefreshAnnouncementEvent(),
                    );
                    context.read<PriorityDeadlineBloc>().add(
                      RefreshPriorityDeadlineEvent(),
                    );
                  },
                  child: ListView(
                    padding: .all(9),
                    children: [
                      BlocBuilder<AnnouncementBloc, AnnouncementState>(
                        builder: (context, state) {
                          if (state is AnnouncementLoading) {
                            return Container(
                              margin: .only(bottom: 16, top: 16),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Card(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Container(
                                    margin: .only(bottom: 16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.white,
                                    ),
                                    padding: .all(16),
                                    width: double.infinity,
                                    height: 100,
                                  ),
                                ),
                              ),
                            );
                          } else if (state is AnnouncementLoaded) {
                            final announcement = state.announcement;
                            if (announcement != null) {
                              return Container(
                                margin: .only(bottom: 16),
                                child: UrgentAnnouncement(
                                  chipText: announcement.chipText,
                                  titleText: announcement.titleText,
                                  bodyText: announcement.bodyText,
                                  timeText: announcement.timeText,
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          }
                          return SizedBox.shrink();
                        },
                      ),
                      BlocBuilder<PriorityDeadlineBloc, PriorityDeadlineState>(
                        builder: (context, state) {
                          if (state is PriorityDeadlineLoading) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Card(
                                margin: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Container(
                                  margin: .only(bottom: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white,
                                  ),
                                  padding: .all(16),
                                  width: double.infinity,
                                  height: 80,
                                ),
                              ),
                            );
                          } else if (state is PriorityDeadlineLoaded) {
                            final priorityDeadline = state.priorityDeadline;
                            if (priorityDeadline != null) {
                              return Container(
                                margin: .only(bottom: 20),
                                child: PriorityDeadlineCard(
                                  title: priorityDeadline.title,
                                  timeLeft: priorityDeadline.remainingTime,
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          }
                          return SizedBox.shrink();
                        },
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
