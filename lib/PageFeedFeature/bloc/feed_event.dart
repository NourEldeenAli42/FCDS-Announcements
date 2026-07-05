part of 'feed_bloc.dart';

sealed class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class LoadFeedPageEvent extends FeedEvent {
  final int pageId;

  const LoadFeedPageEvent({required this.pageId});

  @override
  List<Object> get props => [pageId];
}

class RefreshAnnouncementsEvent extends FeedEvent {
  final int pageId;
  final PageFeedDataModel page;

  const RefreshAnnouncementsEvent({required this.pageId, required this.page});

  @override
  List<Object> get props => [pageId, page];
}

class DeleteAnnouncementEvent extends FeedEvent {
  final int announcementId;


  const DeleteAnnouncementEvent({required this.announcementId});

  @override
  List<Object> get props => [announcementId];
}

class EditAnnouncementEvent extends FeedEvent {
  final AnnouncementDataModel announcement;

  const EditAnnouncementEvent({required this.announcement});

  @override
  List<Object> get props => [announcement];
}

class ToggleNotificationEvent extends FeedEvent {
  final int pageId;

  const ToggleNotificationEvent({required this.pageId});

  @override
  List<Object> get props => [pageId];
}