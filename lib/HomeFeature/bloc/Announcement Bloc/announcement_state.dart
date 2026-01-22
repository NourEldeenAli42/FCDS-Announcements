part of 'announcement_bloc.dart';

sealed class AnnouncementState extends Equatable {
  const AnnouncementState();

  @override
  List<Object> get props => []; 
}

final class AnnouncementInitial extends AnnouncementState {}

final class AnnouncementLoading extends AnnouncementState {}

final class AnnouncementLoaded extends AnnouncementState {
  final UrgentUpdateDataModel? announcement;

  const AnnouncementLoaded(this.announcement);
}
