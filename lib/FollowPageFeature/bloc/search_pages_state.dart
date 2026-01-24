part of 'search_pages_bloc.dart';

sealed class SearchPagesState extends Equatable {
  const SearchPagesState();

  @override
  List<Object> get props => [];
}

final class SearchPagesInitial extends SearchPagesState {}

final class SearchCoursesLoading extends SearchPagesState {}

final class SearchCoursesLoaded extends SearchPagesState {
  final List<CourseDataModel> pages;

  const SearchCoursesLoaded(this.pages);

  @override
  List<Object> get props => [pages];
}

final class SearchCoursesError extends SearchPagesState {
  final String message;

  const SearchCoursesError(this.message);

  @override
  List<Object> get props => [message];
}

final class SearchPagesLoading extends SearchPagesState {}
final class SearchPagesLoaded extends SearchPagesState {
  final List<PageDataModel> pages;

  const SearchPagesLoaded(this.pages);

  @override
  List<Object> get props => [pages];
}
final class SearchPagesError extends SearchPagesState {
  final String message;

  const SearchPagesError(this.message);

  @override
  List<Object> get props => [message];
}