import 'package:fcds_announcements/HomeFeature/Widgets/deadlines_carousel.dart';
import 'package:fcds_announcements/HomeFeature/Widgets/function_card.dart';
import 'package:fcds_announcements/HomeFeature/Widgets/priority_deadline.dart';
import 'package:fcds_announcements/HomeFeature/Widgets/urgent_announcement.dart';
import 'package:fcds_announcements/HomeFeature/bloc/Announcement%20Bloc/announcement_bloc.dart';
import 'package:fcds_announcements/HomeFeature/bloc/Function%20Buttons%20Bloc/function_buttons_bloc.dart';
import 'package:fcds_announcements/HomeFeature/bloc/Priority%20Deadline%20Bloc/priority_deadline_bloc.dart';
import 'package:fcds_announcements/HomeFeature/repositories/priority_deadline_repository.dart';
import 'package:fcds_announcements/HomeFeature/repositories/urgent_update_repository.dart';
import 'package:fcds_announcements/SubjectsFeature/Widgets/add_reminder_form.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FunctionButtonsBloc()..add(LoadReadFunctionButtonsEvent()),
      child: BlocProvider(
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
                      context.read<FunctionButtonsBloc>().add(
                        LoadReadFunctionButtonsEvent(),
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
                                child: Skeletonizer(
                                  child: UrgentAnnouncement.empty(),
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
                                    pageId: announcement.pageId,
                                    redirectLink: announcement.redirectLink,
                                  ),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            }
                            return SizedBox.shrink();
                          },
                        ),
                        BlocBuilder<
                          PriorityDeadlineBloc,
                          PriorityDeadlineState
                        >(
                          builder: (context, state) {
                            if (state is PriorityDeadlineLoading) {
                              return Skeletonizer.zone(
                                child: PriorityDeadlineCard.empty(),
                              );
                            } else if (state is PriorityDeadlineLoaded) {
                              final priorityDeadline = state.priorityDeadline;

                              if (priorityDeadline.isNotEmpty) {
                                if (priorityDeadline.length == 1) {
                                  return PriorityDeadlineCard(
                                    priorityDeadline: priorityDeadline[0],
                                  );
                                }
                                return DeadlinesCarousel(
                                  priorityDeadlines: priorityDeadline,
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            }
                            return SizedBox.shrink();
                          },
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            BlocBuilder<
                              FunctionButtonsBloc,
                              FunctionButtonsState
                            >(
                              builder: (context, state) {
                                if (state is FunctionButtonsReadLoaded) {
                                  return FunctionCard(
                                    hasUnread: state.hasUnreadMessages,
                                    icon: Icons.messenger_outline_sharp,
                                    label: 'Messages',
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    onTap: () {
                                      Navigator.pushNamed(context, '/messages');
                                    },
                                  );
                                } else {
                                  return FunctionCard(
                                    icon: Icons.messenger_outline_sharp,
                                    label: 'Messages',
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    onTap: () {
                                      Navigator.pushNamed(context, '/messages');
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        FunctionCard(
                          icon: Icons.alarm,
                          label: 'Set Reminder',
                          color: Theme.of(context).colorScheme.tertiary,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Set Reminder'),
                                  content: AddReminderForm(),
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        BlocBuilder<FunctionButtonsBloc, FunctionButtonsState>(
                          builder: (context, state) {
                            if (state is FunctionButtonsReadLoaded &&
                                state.isAdmin) {
                              return FunctionCard(
                                hasUnread: false,
                                icon: Icons.admin_panel_settings,
                                label: 'Admin Panel',
                                color: Theme.of(context).colorScheme.error,
                                onTap: () {
                                  Navigator.pushNamed(context, '/admin');
                                },
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
                      ],
                    ),
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
