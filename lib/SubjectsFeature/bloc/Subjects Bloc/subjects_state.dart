part of 'subjects_bloc.dart';

sealed class SubjectsState extends Equatable {
  const SubjectsState();
  
  @override
  List<Object> get props => [];
}

final class SubjectsInitial extends SubjectsState {}
final class SubjectsLoading extends SubjectsState {}
final class SubjectsLoaded extends SubjectsState {
  final List<CourseDataModel> subjects;

  const SubjectsLoaded({required this.subjects});

  @override
  List<Object> get props => [subjects];
}
final class SubjectsError extends SubjectsState {
  final String message;

  const SubjectsError({required this.message});

  @override
  List<Object> get props => [message];
}
