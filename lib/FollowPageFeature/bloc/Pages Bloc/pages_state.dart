part of 'pages_bloc.dart';

sealed class PagesState extends Equatable {
  const PagesState();

  @override
  List<Object> get props => [];
}

final class PagesInitial extends PagesState {}

final class SearchCoursesLoading extends PagesState {}

final class SearchCoursesLoaded extends PagesState {
  final List<CourseDataModel> pages;

  const SearchCoursesLoaded(this.pages);

  @override
  List<Object> get props => [pages];
}

final class SearchCoursesError extends PagesState {
  final String message;

  const SearchCoursesError(this.message);

  @override
  List<Object> get props => [message];
}

final class SearchPagesLoading extends PagesState {}

final class SearchPagesLoaded extends PagesState {
  final List<PageDataModel> pages;

  const SearchPagesLoaded(this.pages);

  @override
  List<Object> get props => [pages];
}

final class SearchPagesError extends PagesState {
  final String message;

  const SearchPagesError(this.message);

  @override
  List<Object> get props => [message];
}
