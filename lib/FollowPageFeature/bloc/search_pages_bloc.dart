import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/repositories/pages_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_pages_event.dart';
part 'search_pages_state.dart';

class SearchPagesBloc extends Bloc<SearchPagesEvent, SearchPagesState> {
  PagesRepository pagesRepository = PagesRepository();
  SearchPagesBloc() : super(SearchPagesInitial()) {
    on<SearchPagesEvent>((event, emit) async {
      if (event is FetchCoursesEvent) {
        emit(SearchCoursesLoading());
        final courses = await pagesRepository.fetchAllCourses();
        emit(SearchCoursesLoaded(courses));
      }
      else if (event is FetchPagesEvent) {
        emit(SearchPagesLoading());
        final pages = await pagesRepository.fetchCourseSpecificPages(event.courseName);
        emit(SearchPagesLoaded(pages));
      }
    });
  }
}
