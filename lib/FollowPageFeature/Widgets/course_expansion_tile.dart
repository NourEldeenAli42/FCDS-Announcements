import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/bloc/search_pages_bloc.dart';
import 'package:fcds_announcements/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class CourseExpansionTile extends StatefulWidget {
  final CourseDataModel page;
  const CourseExpansionTile({super.key, required this.page});

  @override
  State<CourseExpansionTile> createState() => _CourseExpansionTileState();
}

class _CourseExpansionTileState extends State<CourseExpansionTile> {
  late SearchPagesBloc _searchPagesBloc;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _searchPagesBloc = SearchPagesBloc();
  }

  @override
  void didUpdateWidget(CourseExpansionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset expansion state when the page changes (e.g., when search results change)
    if (oldWidget.page.id != widget.page.id) {
      setState(() {
        _isExpanded = false;
      });
      // Reset the bloc to clear previous state
      _searchPagesBloc.close();
      _searchPagesBloc = SearchPagesBloc();
    }
  }

  @override
  void dispose() {
    _searchPagesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchPagesBloc,
      child: BlocBuilder<SearchPagesBloc, SearchPagesState>(
        builder: (context, state) {
          return ExpansionTile(
            initiallyExpanded: _isExpanded,
            shape: Border(),
            onExpansionChanged: (value) {
              setState(() {
                _isExpanded = value;
              });
              if (value) {
                context.read<SearchPagesBloc>().add(
                  FetchPagesEvent(widget.page.name),
                );
              }
            },
            title: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color.fromARGB(255, 231, 245, 240),
                  child: Icon(
                    Icons.calculate_rounded,
                    color: Color.fromARGB(255, 22, 156, 112),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.page.name.trim(),
                    style: MyTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            children: [
              if (state is SearchPagesLoading)
                Center(
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
                )
              else if (state is SearchPagesLoaded && state.pages.isNotEmpty)
                ...state.pages.map(
                  (p) => ListTile(
                    trailing: OutlinedButton(
                      onPressed: () {},
                      child: Text('Follow'),
                    ),
                    title: Text(
                      p.title,
                      style: MyTextStyle(fontSize: 16, fontWeight: .bold),
                    ),
                    subtitle: Wrap(
                      children: [
                        for (var tag in p.tags)
                          Container(
                            margin: EdgeInsets.only(right: 6, top: 4),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: .min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Colors.blueGrey.shade800,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  tag,
                                  style: MyTextStyle(
                                    fontSize: 12,
                                    color: Colors.blueGrey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              if (state is SearchPagesLoaded && state.pages.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No pages found for this course.',
                    style: MyTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
