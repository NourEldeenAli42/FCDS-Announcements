import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
import 'package:fcds_announcements/PageFeedFeature/Widgets/announcement.dart';
import 'package:fcds_announcements/PageFeedFeature/bloc/feed_bloc.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timelines_plus/timelines_plus.dart';

class PageFeedView extends StatelessWidget {
  final CourseDataModel subject;
  final PageDataModel page;
  const PageFeedView({super.key, required this.subject, required this.page});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FeedBloc()..add(LoadAnnouncementsEvent(pageId: page.id)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${subject.name} ${page.title}",
            style: MyTextStyle(fontSize: 20, fontWeight: .bold),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new),
            color: Color.fromARGB(255, 34, 125, 109),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Announcements',
                    style: MyTextStyle(fontSize: 24, fontWeight: .bold),
                  ),
                  Spacer(),
                  BlocBuilder<FeedBloc, FeedState>(
                    builder: (context, state) {
                      if (state is FeedLoading) {
                        return SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is FeedLoaded) {
                        return Container(
                          color: Color.fromARGB(255, 230, 239, 236),
                          child: Text(
                            '${state.announcements.length} Posts',
                            style: MyTextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 81, 149, 126),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ],
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
                          indicatorTheme: IndicatorThemeData(size: 20.0),
                        ),
                        builder: TimelineTileBuilder(
                          contentsAlign: .basic,
                          indicatorBuilder: (context, index) => DotIndicator(
                            color: Color.fromARGB(255, 34, 125, 109),
                          ),
                          endConnectorBuilder: (context, index) =>
                              SolidLineConnector(color: Colors.grey.shade300),
                          startConnectorBuilder: (context, index) =>
                              SolidLineConnector(color: Colors.grey.shade300),
                          itemCount: state.announcements.length,
                          contentsBuilder: (context, index) => Announcement(
                            announcement: state.announcements[index],
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
  }
}
