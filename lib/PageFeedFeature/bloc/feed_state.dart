part of 'feed_bloc.dart';

sealed class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

final class FeedInitial extends FeedState {}

final class FeedLoading extends FeedState {}

final class FeedLoaded extends FeedState {
  final List<AnnouncementDataModel> announcements;
  final PageFeedDataModel page;
  final bool isAdmin;
  final bool isNotificationEnabled;
  final bool isTogglingNotifications;

  const FeedLoaded({
    required this.announcements,
    required this.page,
    required this.isAdmin,
    required this.isNotificationEnabled,
    this.isTogglingNotifications = false,
  });

  @override
  List<Object> get props => [
    announcements,
    page,
    isAdmin,
    isNotificationEnabled,
    isTogglingNotifications,
  ];
}

final class FeedError extends FeedState {
  final String message;
  const FeedError({required this.message});
  @override
  List<Object> get props => [message];
}
