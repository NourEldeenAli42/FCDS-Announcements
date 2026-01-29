import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/SubjectsFeature/bloc/Subject%20Tile%20Bloc/subject_tile_bloc.dart';
import 'package:fcds_announcements/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectTile extends StatelessWidget {
  final Color color;
  final IconData icon = Icons.book;
  final CourseDataModel subject;
  const SubjectTile({
    super.key,
    required this.subject,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        onExpansionChanged: (value) {
          if (value) {
            context.read<SubjectTileBloc>().add(
              LoadFollowedPagesofSubjectEvent(subjectId: subject.id),
            );
          } else {
            // Tile collapsed
          }
        },
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: color.computeLuminance() < 0.5
              ? color.withValues(alpha: 0.2)
              : color.withValues(alpha: 0.6),
          child: Icon(icon, size: 28, color: color),
        ),
        collapsedShape: Border(),
        shape: Border(),
        title: Text(
          subject.name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        children: [
          BlocBuilder<SubjectTileBloc, SubjectTileState>(
            builder: (context, state) {
              return Container(
                margin: .all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 30,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        Text(
                          'Upcoming Exam',
                          style: MyTextStyle(
                            fontSize: 16,
                            fontWeight: .bold,
                            color: Color.fromARGB(255, 146, 96, 38),
                          ),
                        ),
                        Text(
                          'Date: 25th Dec 2024',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 199, 165, 70),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          BlocBuilder<SubjectTileBloc, SubjectTileState>(
            builder: (context, state) {
              return Container(
                alignment: Alignment.center,
                child: switch (state) {
                  SubjectTileInitial() ||
                  FollowedPagesLoading() => CircularProgressIndicator(),
                  FollowedPagesLoaded(:final pages) =>
                    pages.isEmpty
                        ? Text(
                            'No followed pages for this subject.',
                            style: MyTextStyle(color: Colors.grey[600]),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: pages
                                .map(
                                  (page) => ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),

                                    title: Text(
                                      page.title,
                                      style: MyTextStyle(fontSize: 16),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                  FollowedPagesError(:final message) => Text(
                    'Error: $message',
                    style: MyTextStyle(color: Colors.red),
                  ),
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
