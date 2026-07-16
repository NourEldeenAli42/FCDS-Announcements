import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/SubjectsFeature/Widgets/subject_tile.dart';
import 'package:fcds_announcements/SubjectsFeature/bloc/Subject%20Tile%20Bloc/subject_tile_bloc.dart';
import 'package:fcds_announcements/SubjectsFeature/bloc/Subjects%20Bloc/subjects_bloc.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SubjectsView extends StatelessWidget {
  const SubjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<SubjectsBloc>().add(const LoadSubjectsEvent());
          },
          child: ListView(
            children: [
              Text(
                'My Subjects',
                style: MyTextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              Text(
                'Manage your enrollment and stay updated.',
                style: MyTextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              BlocBuilder<SubjectsBloc, SubjectsState>(
                builder: (context, state) {
                  return switch (state) {
                    SubjectsInitial() || SubjectsLoading() => Skeletonizer.zone(
                      child: Column(
                        children: List.generate(
                          3,
                          (index) => const SubjectTile.empty(),
                        ),
                      ),
                    ),
                    SubjectsLoaded(:final subjects) =>
                      subjects.isEmpty
                          ? Center(
                              child: Text(
                                'No subjects found. Please add subjects to stay updated.',
                                style: MyTextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            )
                          : Column(
                              children: subjects
                                  .map(
                                    (subject) => BlocProvider(
                                      create: (context) => SubjectTileBloc(),
                                      child: SubjectTile(subject: subject),
                                    ),
                                  )
                                  .toList(),
                            ),
                    SubjectsError(:final message) => Center(
                      child: Text(
                        'Error: $message',
                        style: MyTextStyle(color: Colors.red),
                      ),
                    ),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
