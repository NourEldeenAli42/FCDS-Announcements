import 'package:fcds_announcements/AdminFeature/Widgets/notification_example.dart';
import 'package:fcds_announcements/AdminFeature/bloc/add_announcements_cubit/add_announcements_cubit.dart';
import 'package:fcds_announcements/HomeFeature/Widgets/priority_deadline.dart';
import 'package:fcds_announcements/HomeFeature/Widgets/urgent_announcement.dart';
import 'package:fcds_announcements/PageFeedFeature/Widgets/announcement.dart';
import 'package:fcds_announcements/utils/app_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAnnouncementView extends StatelessWidget {
  final int pageId;
  const AddAnnouncementView({super.key, required this.pageId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddAnnouncementsCubit(),
      child: BlocListener<AddAnnouncementsCubit, AddAnnouncementsCubitState>(
        listener: (context, state) {
          if (state is AddAnnouncementsCubitSuccess) {
            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Text(state.message),
                shape: StadiumBorder(),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AddAnnouncementsCubitError) {
            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Text(state.message),
                shape: StadiumBorder(),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(title: Text('Add Announcement')),
          body: Builder(
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    UrgentAnnouncement.editing(
                      onSubmit:
                          ({
                            required chipText,
                            required title,
                            required body,
                            required notificationEnabled,
                            required redirectLink,
                          }) {
                            context
                                .read<AddAnnouncementsCubit>()
                                .addUrgentAnnouncement(
                                  chipText: chipText,
                                  title: title,
                                  content: body,
                                  notificationEnabled: notificationEnabled,
                                  pageId: pageId,
                                  redirectLink: redirectLink,
                                );
                          },
                    ),
                    Announcement.editing(
                      onSubmit:
                          ({
                            required body,
                            required date,
                            required redirectLink,
                            required title,
                          }) {
                            context
                                .read<AddAnnouncementsCubit>()
                                .addAnnouncement(
                                  title: title,
                                  content: body,
                                  pageId: pageId,
                                  redirectLink: redirectLink,
                                );
                          },
                    ),
                    NotificationExample(
                      message: "This is a sample notification message.",
                      title: "Sample Notification",
                      icon: Icons.notifications,
                      onSubmit: (title, message) {
                        context.read<AddAnnouncementsCubit>().sendNotification(
                          title: title,
                          content: message,
                          pageId: pageId,
                        );
                      },
                    ),
                    PriorityDeadlineCard.editing(
                      onSubmit:
                          ({
                            required deadline,
                            required notificationEnabled,
                            required title,
                          }) {
                            context
                                .read<AddAnnouncementsCubit>()
                                .addPriorityDeadline(
                                  title: title,
                                  deadline: deadline,
                                  notificationEnabled: notificationEnabled,
                                  pageId: pageId,
                                );
                            if (notificationEnabled) {
                              context
                                  .read<AddAnnouncementsCubit>()
                                  .sendNotification(
                                    title: title,
                                    content:
                                        'New Deadline is set for ${deadline.weekday}, ${deadline.month}/${deadline.day}/${deadline.year} at ${deadline.hour}:${deadline.minute}',
                                    pageId: pageId,
                                  );
                            }
                          },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
