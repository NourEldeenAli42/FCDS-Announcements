part of 'add_announcements_cubit.dart';

sealed class AddAnnouncementsCubitState extends Equatable {
  const AddAnnouncementsCubitState();

  @override
  List<Object> get props => [];
}

final class AddAnnouncementsCubitInitial extends AddAnnouncementsCubitState {}

final class AddAnnouncementsCubitLoading extends AddAnnouncementsCubitState {}

final class AddAnnouncementsCubitSuccess extends AddAnnouncementsCubitState {
  final String message;
  const AddAnnouncementsCubitSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

final class AddAnnouncementsCubitError extends AddAnnouncementsCubitState {
  final String message;
  const AddAnnouncementsCubitError({required this.message});
  @override
  List<Object> get props => [message];
}