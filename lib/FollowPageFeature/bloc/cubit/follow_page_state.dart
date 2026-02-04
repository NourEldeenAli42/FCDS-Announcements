part of 'follow_page_cubit.dart';

sealed class FollowPageState extends Equatable {
  const FollowPageState();

  @override
  List<Object> get props => [];
}

final class FollowPageInitial extends FollowPageState {}

final class FollowPageLoading extends FollowPageState {}

final class FollowPageFollowed extends FollowPageState {}

final class FollowPageUnfollowed extends FollowPageState {}
