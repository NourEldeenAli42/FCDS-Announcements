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

  const FeedLoaded({required this.announcements});

  @override
  List<Object> get props => [announcements];
}
final class FeedError extends FeedState {
  final String message;
  const FeedError({required this.message});
  @override
  List<Object> get props => [message];
}