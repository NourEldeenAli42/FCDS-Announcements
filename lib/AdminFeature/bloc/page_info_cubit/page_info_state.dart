part of 'page_info_cubit.dart';

sealed class PageInfoState extends Equatable {
  const PageInfoState();

  @override
  List<Object> get props => [];
}

final class PageInfoInitial extends PageInfoState {}
final class PageInfoLoading extends PageInfoState {}
final class PageInfoLoaded extends PageInfoState {
  final List<InstructorDataModel> instructors;
  const PageInfoLoaded({required this.instructors});
}
final class PageInfoError extends PageInfoState {
  final String message;
  const PageInfoError({required this.message});
}