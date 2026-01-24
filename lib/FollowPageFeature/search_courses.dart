import 'package:fcds_announcements/FollowPageFeature/Widgets/course_expansion_tile.dart';
import 'package:fcds_announcements/FollowPageFeature/bloc/search_pages_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class SearchCourses extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchPagesBloc()..add(FetchCoursesEvent()),
      child: BlocBuilder<SearchPagesBloc, SearchPagesState>(
        builder: (context, state) {
          if (state is SearchCoursesLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is SearchCoursesLoaded) {
            final results = state.pages;
            final filteredResults = results
                .where(
                  (course) =>
                      course.name.toLowerCase().contains(query.toLowerCase()) ||
                      course.id.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
            if (results.isEmpty) {
              return Center(child: Text('No courses found.'));
            }
            return ListView.builder(
              itemCount: filteredResults.length,
              itemBuilder: (context, index) {
                final page = filteredResults[index];
                return CourseExpansionTile(page: page);
              },
            );
          } else if (state is SearchCoursesError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('Search for courses...'));
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchPagesBloc()..add(FetchCoursesEvent()),
      child: BlocBuilder<SearchPagesBloc, SearchPagesState>(
        builder: (context, state) {
          if (state is SearchCoursesLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is SearchCoursesLoaded) {
            final results = state.pages;
            final filteredResults = results
                .where(
                  (course) =>
                      course.name.toLowerCase().contains(query.toLowerCase()) ||
                      course.id.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
            return ListView.builder(
              itemCount: filteredResults.length,
              itemBuilder: (context, index) {
                final page = filteredResults[index];
                return CourseExpansionTile(page: page);
              },
            );
          } else if (state is SearchCoursesError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('Search for courses...'));
        },
      ),
    );
  }
}
