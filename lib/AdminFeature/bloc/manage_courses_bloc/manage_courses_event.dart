part of 'manage_courses_bloc.dart';

sealed class ManageCoursesEvent extends Equatable {
  const ManageCoursesEvent();

  @override
  List<Object> get props => [];
}
class LoadCourses extends ManageCoursesEvent {}
class UpdateCourse extends ManageCoursesEvent {
  final CourseDataModel course;

  const UpdateCourse(this.course);

  @override
  List<Object> get props => [course];
}
class RefreshCourses extends ManageCoursesEvent {
}