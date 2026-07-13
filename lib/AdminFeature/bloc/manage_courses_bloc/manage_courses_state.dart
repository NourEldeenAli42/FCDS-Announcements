part of 'manage_courses_bloc.dart';

sealed class ManageCoursesState extends Equatable {
  const ManageCoursesState();
  
  @override
  List<Object> get props => [];
}

final class ManageCoursesInitial extends ManageCoursesState {}

final class ManageCoursesLoading extends ManageCoursesState {}

final class ManageCoursesLoaded extends ManageCoursesState {
  final List<CourseDataModel> courses;

  const ManageCoursesLoaded(this.courses);

  @override
  List<Object> get props => [courses];
}
final class ManageCoursesError extends ManageCoursesState {
  final String message;

  const ManageCoursesError(this.message);

  @override
  List<Object> get props => [message];
}
final class ManageCoursesUpdated extends ManageCoursesState {
  final CourseDataModel updatedCourse;

  const ManageCoursesUpdated(this.updatedCourse);

  @override
  List<Object> get props => [updatedCourse];
}