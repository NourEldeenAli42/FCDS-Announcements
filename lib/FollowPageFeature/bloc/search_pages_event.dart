part of 'search_pages_bloc.dart';

sealed class SearchPagesEvent extends Equatable {
  const SearchPagesEvent();

  @override
  List<Object> get props => [];
}

class FetchCoursesEvent extends SearchPagesEvent {}

class FetchPagesEvent extends SearchPagesEvent {
  final String courseName;
  const FetchPagesEvent(this.courseName);
}
