part of 'manage_pages_bloc.dart';

sealed class ManagePagesState extends Equatable {
  const ManagePagesState();
  
  @override
  List<Object> get props => [];
}

final class ManagePagesInitial extends ManagePagesState {}
final class ManagePagesLoading extends ManagePagesState {}
final class ManagePagesLoaded extends ManagePagesState {
  final List<Map<CourseDataModel, List<PageDataModel>>> pages;
  const ManagePagesLoaded({required this.pages});
}
final class ManagePagesError extends ManagePagesState {
  final String message;
  const ManagePagesError({required this.message});
}