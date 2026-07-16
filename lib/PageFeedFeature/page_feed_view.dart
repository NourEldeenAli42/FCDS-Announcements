import 'package:fcds_announcements/AdminFeature/add_announcement_view.dart';
import 'package:fcds_announcements/PageFeedFeature/Data%20Models/announcement_data_model.dart';
import 'package:fcds_announcements/PageFeedFeature/Widgets/announcement.dart';
import 'package:fcds_announcements/PageFeedFeature/bloc/feed_bloc.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timelines_plus/timelines_plus.dart';

class PageFeedView extends StatelessWidget {
  final int pageId;
  const PageFeedView({super.key, required this.pageId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedBloc()..add(LoadFeedPageEvent(pageId: pageId)),
      child: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          if (state is FeedLoading) {
            return Scaffold(
              body: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (state is FeedLoaded) {
            final page = state.page;
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "${page.courseName} ${page.pageType}",
                  style: MyTextStyle(fontSize: 20, fontWeight: .bold),
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new),
                ),
              ),
              floatingActionButton: BlocBuilder(
                bloc: context.read<FeedBloc>(),
                builder: (context, state) {
                  if (state is FeedLoaded && state.isAdmin) {
                    return FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddAnnouncementView(pageId: page.pageId),
                          ),
                        );
                      },
                      backgroundColor: Color.fromARGB(255, 34, 125, 109),
                      child: Icon(Icons.add, color: Colors.white),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<FeedBloc>().add(
                      LoadFeedPageEvent(pageId: page.pageId),
                    );
                  },
                  child: Column(
                    children: [
                      BlocBuilder<FeedBloc, FeedState>(
                        builder: (context, state) {
                          if (state is FeedLoaded) {
                            return Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Text(
                                  'Announcements',
                                  style: MyTextStyle(
                                    fontSize: 24,
                                    fontWeight: .bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.read<FeedBloc>().add(
                                      ToggleNotificationEvent(
                                        pageId: page.pageId,
                                      ),
                                    );
                                  },
                                  child: (state.isTogglingNotifications)
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                          ),
                                        )
                                      : (state.isNotificationEnabled)
                                      ? FaIcon(
                                          FontAwesomeIcons.bell,
                                          color: Color.fromARGB(
                                            255,
                                            34,
                                            125,
                                            109,
                                          ),
                                        )
                                      : FaIcon(
                                          FontAwesomeIcons.bellSlash,
                                          color: Colors.grey,
                                        ),
                                ),
                                Text(
                                  '${state.announcements.length} Posts',
                                  style: MyTextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 81, 149, 126),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                      Expanded(
                        child: BlocBuilder<FeedBloc, FeedState>(
                          builder: (context, state) {
                            if (state is FeedLoading) {
                              return Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (state is FeedLoaded &&
                                state.announcements.isNotEmpty) {
                              return Timeline.tileBuilder(
                                theme: TimelineThemeData(
                                  nodePosition: 0,
                                  connectorTheme: ConnectorThemeData(
                                    thickness: 2.0,
                                    color: Colors.grey.shade300,
                                  ),
                                  indicatorTheme: IndicatorThemeData(
                                    size: 20.0,
                                  ),
                                ),
                                builder: TimelineTileBuilder(
                                  contentsAlign: .basic,
                                  indicatorBuilder: (context, index) =>
                                      DotIndicator(
                                        color: Color.fromARGB(
                                          255,
                                          34,
                                          125,
                                          109,
                                        ),
                                      ),
                                  endConnectorBuilder: (context, index) =>
                                      SolidLineConnector(
                                        color: Colors.grey.shade300,
                                      ),
                                  startConnectorBuilder: (context, index) =>
                                      SolidLineConnector(
                                        color: Colors.grey.shade300,
                                      ),
                                  itemCount: state.announcements.length,
                                  contentsBuilder: (context, index) => Stack(
                                    children: [
                                      Announcement(
                                        announcement:
                                            state.announcements[index],
                                        isAdmin: state.isAdmin,
                                        onDelete: state.isAdmin
                                            ? () {
                                                context.read<FeedBloc>().add(
                                                  DeleteAnnouncementEvent(
                                                    announcementId: state
                                                        .announcements[index]
                                                        .id,
                                                  ),
                                                );
                                              }
                                            : null,
                                        onEdit: state.isAdmin
                                            ? () {
                                                final feedBloc = context
                                                    .read<FeedBloc>();
                                                showAdaptiveDialog(
                                                  context: context,
                                                  builder: (dialogContext) {
                                                    return BlocProvider.value(
                                                      value: feedBloc,
                                                      child: Center(
                                                        child: Announcement.editing(
                                                          announcement: state
                                                              .announcements[index],
                                                          onSubmit:
                                                              ({
                                                                required title,
                                                                required body,
                                                                required date,
                                                                required redirectLink,
                                                              }) {
                                                                context.read<FeedBloc>().add(
                                                                  EditAnnouncementEvent(
                                                                    announcement: AnnouncementDataModel(
                                                                      id: state
                                                                          .announcements[index]
                                                                          .id,
                                                                      date: state
                                                                          .announcements[index]
                                                                          .date,
                                                                      title:
                                                                          title,
                                                                      content:
                                                                          body,
                                                                      redirectLink:
                                                                          redirectLink,
                                                                      deadline: state
                                                                          .announcements[index]
                                                                          .deadline,
                                                                    ),
                                                                  ),
                                                                );
                                                                Navigator.pop(
                                                                  dialogContext,
                                                                );
                                                              },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                              );
                            } else if (state is FeedLoaded &&
                                state.announcements.isEmpty) {
                              return Center(
                                child: Text(
                                  'No announcements available',
                                  style: MyTextStyle(fontSize: 16),
                                ),
                              );
                            } else {
                              return Center(
                                child: Text(
                                  'Failed to load announcements',
                                  style: MyTextStyle(fontSize: 16),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                'Failed to load announcements',
                style: MyTextStyle(fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}
