import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/AdminFeature/repositories/admin_repository.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manage_courses_event.dart';
part 'manage_courses_state.dart';

class ManageCoursesBloc extends Bloc<ManageCoursesEvent, ManageCoursesState> {
  ManageCoursesBloc() : super(ManageCoursesInitial()) {
    on<ManageCoursesEvent>((event, emit) async {
      if (event is LoadCourses) {
        emit(ManageCoursesLoading());
        try {
          final courses = await AdminRepository.fetchCourses();
          emit(ManageCoursesLoaded(courses));
        } catch (e) {
          emit(ManageCoursesError(e.toString()));
        }
      } else if (event is UpdateCourse) {
        emit(ManageCoursesLoading());
        try {
          await AdminRepository.updateCourse(event.course);
          emit(ManageCoursesUpdated(event.course));
        } catch (e) {
          emit(ManageCoursesError(e.toString()));
        }
      } else if (event is RefreshCourses) {
        emit(ManageCoursesLoading());
        try {
          final courses = await AdminRepository.fetchCourses();
          emit(ManageCoursesLoaded(courses));
        } catch (e) {
          emit(ManageCoursesError(e.toString()));
        }
      }
    });
  }
}
