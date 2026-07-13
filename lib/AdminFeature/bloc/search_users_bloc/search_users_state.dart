part of 'search_users_bloc.dart';

sealed class SearchUsersState extends Equatable {
  const SearchUsersState();

  @override
  List<Object> get props => [];
}

final class SearchUsersInitial extends SearchUsersState {}

final class SearchResultsLoading extends SearchUsersState {}

final class SearchResultsLoaded extends SearchUsersState {
  final List<UserDataModel> users;
  final int totalUsers;
  final int totalAdmins;

  const SearchResultsLoaded(this.users, this.totalUsers, this.totalAdmins);

  @override
  List<Object> get props => [users, totalUsers, totalAdmins];
}

final class SearchResultsError extends SearchUsersState {
  final String error;

  const SearchResultsError(this.error);

  @override
  List<Object> get props => [error];
}

final class RequestSentState extends SearchUsersState {
  final String message;

  const RequestSentState(this.message);

  @override
  List<Object> get props => [message];
}