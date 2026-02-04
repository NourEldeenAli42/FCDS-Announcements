import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/bloc/Pages%20Bloc/pages_bloc.dart';
import 'package:fcds_announcements/FollowPageFeature/bloc/cubit/follow_page_cubit.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
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
  late PagesBloc _searchPagesBloc;
  late FollowPageCubit _followCubit;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _searchPagesBloc = PagesBloc();
    _followCubit = FollowPageCubit(widget.page.id);
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
      _searchPagesBloc = PagesBloc();
      _followCubit.close();
      _followCubit = FollowPageCubit(widget.page.id);
    }
  }

  @override
  void dispose() {
    _searchPagesBloc.close();
    _followCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _followCubit,
      child: BlocProvider.value(
        value: _searchPagesBloc,
        child: BlocBuilder<PagesBloc, PagesState>(
          builder: (context, state) {
            return ExpansionTile(
              initiallyExpanded: _isExpanded,
              shape: Border(),
              onExpansionChanged: (value) {
                setState(() {
                  _isExpanded = value;
                });
                if (value) {
                  context.read<PagesBloc>().add(
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
                    (p) => BlocProvider(
                      create: (context) => FollowPageCubit(p.id),
                      child: ListTile(
                        trailing: BlocBuilder<FollowPageCubit, FollowPageState>(
                          builder: (context, state) {
                            switch (state) {
                              case FollowPageFollowed():
                                return OutlinedButton(
                                  style: ButtonStyle(),
                                  onPressed: () {
                                    context
                                        .read<FollowPageCubit>()
                                        .unfollowPage(p.id);
                                  },
                                  child: Text(
                                    'Unfollow',
                                    style: MyTextStyle(
                                      color: Colors.red,
                                      fontWeight: .w700,
                                    ),
                                  ),
                                );
                              case FollowPageLoading() || FollowPageInitial():
                                return SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Color.fromARGB(255, 53, 125, 101),
                                  ),
                                );
                              case FollowPageUnfollowed():
                                return OutlinedButton(
                                  onPressed: () {
                                    context.read<FollowPageCubit>().followPage(
                                      p.id,
                                    );
                                  },
                                  child: Text(
                                    'Follow',
                                    style: MyTextStyle(
                                      color: Color.fromARGB(255, 53, 125, 101),
                                      fontWeight: .w700,
                                    ),
                                  ),
                                );
                            }
                          },
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
      ),
    );
  }
}
