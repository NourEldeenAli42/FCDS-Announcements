part of 'announcement_bloc.dart';

sealed class AnnouncementEvent extends Equatable {
  const AnnouncementEvent();

  @override
  List<Object> get props => [];
}
class LoadAnnouncementEvent extends AnnouncementEvent {
  const LoadAnnouncementEvent();
}

class LoadMoreAnnouncementEvent extends AnnouncementEvent {
  const LoadMoreAnnouncementEvent();
}
class RefreshAnnouncementEvent extends AnnouncementEvent {
  const RefreshAnnouncementEvent();
}