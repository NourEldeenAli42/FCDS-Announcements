part of 'search_users_bloc.dart';

sealed class SearchUsersEvent extends Equatable {
  const SearchUsersEvent();

  @override
  List<Object> get props => [];
}

class SearchUsersInitialEvent extends SearchUsersEvent {
  const SearchUsersInitialEvent();
}

class SearchUsersQueryChangedEvent extends SearchUsersEvent {
  final List<UserDataModel> users;
  final String query;

  const SearchUsersQueryChangedEvent(this.query, {required this.users});

  @override
  List<Object> get props => [query, users];
}

class RemoveAdminPermissionEvent extends SearchUsersEvent {
  final UserDataModel user;

  const RemoveAdminPermissionEvent(this.user);

  @override
  List<Object> get props => [user];
}

class AddAdminPermissionEvent extends SearchUsersEvent {
  final UserDataModel user;

  const AddAdminPermissionEvent(this.user);

  @override
  List<Object> get props => [user];
}

class RefreshSearchUsersEvent extends SearchUsersEvent {
  const RefreshSearchUsersEvent();
}