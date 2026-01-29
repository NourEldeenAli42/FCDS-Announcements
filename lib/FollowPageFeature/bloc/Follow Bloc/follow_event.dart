part of 'follow_bloc.dart';

sealed class FollowEvent extends Equatable {
  const FollowEvent();

  @override
  List<Object> get props => [];
}
class FollowPageEvent extends FollowEvent {
  final String pageName;
  final bool isFollowed;
  const FollowPageEvent({required this.pageName , required this.isFollowed});
}