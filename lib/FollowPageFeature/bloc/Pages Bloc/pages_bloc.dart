import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/repositories/pages_repository.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pages_event.dart';
part 'pages_state.dart';

class PagesBloc extends Bloc<PagesEvent, PagesState> {
  UserRepository userRepository = UserRepository();
  PagesRepository pagesRepository = PagesRepository();
  PagesBloc() : super(PagesInitial()) {
    on<PagesEvent>((event, emit) async {
      if (event is FetchCoursesEvent) {
        emit(SearchCoursesLoading());
        final courses = await pagesRepository.fetchAllCourses();
        emit(SearchCoursesLoaded(courses));
      } else if (event is FetchPagesEvent) {
        emit(SearchPagesLoading());
        final pages = await pagesRepository.fetchCourseSpecificPages(
          event.courseName,
        );
        emit(SearchPagesLoaded(pages));
      }
    });
  }
}
