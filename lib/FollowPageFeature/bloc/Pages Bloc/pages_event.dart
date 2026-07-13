part of 'pages_bloc.dart';

sealed class PagesEvent extends Equatable {
  const PagesEvent();

  @override
  List<Object> get props => [];
}

class FetchCoursesEvent extends PagesEvent {}

class FetchPagesEvent extends PagesEvent {
  final int courseId;
  const FetchPagesEvent(this.courseId);
}
