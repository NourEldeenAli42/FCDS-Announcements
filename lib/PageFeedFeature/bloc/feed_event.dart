part of 'feed_bloc.dart';

sealed class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}
class LoadAnnouncementsEvent extends FeedEvent {
  final String pageId;

  const LoadAnnouncementsEvent({required this.pageId});

  @override
  List<Object> get props => [pageId];
}
class RefreshAnnouncementsEvent extends FeedEvent {
  final String pageId;

  const RefreshAnnouncementsEvent({required this.pageId});

  @override
  List<Object> get props => [pageId];
}