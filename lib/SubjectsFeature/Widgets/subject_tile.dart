import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/SubjectsFeature/Widgets/page_warning.dart';
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
          radius: 20,
          backgroundColor: color.computeLuminance() < 0.5
              ? color.withValues(alpha: 0.2)
              : color.withValues(alpha: 0.6),
          child: Icon(icon, size: 20, color: color),
        ),
        collapsedShape: Border(),
        shape: Border(),
        title: Text(
          subject.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        children: [
          BlocBuilder<SubjectTileBloc, SubjectTileState>(
            builder: (context, state) {
              return PageWarning();
            },
          ),
          BlocBuilder<SubjectTileBloc, SubjectTileState>(
            builder: (context, state) {
              return Container(
                alignment: Alignment.center,
                child: switch (state) {
                  SubjectTileInitial() || FollowedPagesLoading() => Container(
                    margin: .all(20),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 53, 125, 101),
                    ),
                  ),
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
                                    onTap: () {
                                      // TODO: Route to page details and announcements
                                    },
                                    trailing: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: Colors.grey.shade700,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),

                                    title: Text(
                                      page.title,
                                      style: MyTextStyle(
                                        fontSize: 20,
                                        fontWeight: .w500,
                                      ),
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
