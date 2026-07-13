import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/AdminFeature/Data%20Models/user_data_model.dart';
import 'package:fcds_announcements/AdminFeature/repositories/admin_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_users_event.dart';
part 'search_users_state.dart';

class SearchUsersBloc extends Bloc<SearchUsersEvent, SearchUsersState> {
  SearchUsersBloc() : super(SearchUsersInitial()) {
    List<UserDataModel> users = [];
    on<SearchUsersEvent>((event, emit) async {
      if (event is SearchUsersInitialEvent) {
        emit(SearchResultsLoading());
        try {
          // Fetch all users from the database
          users = await AdminRepository.getAllUsers();
          emit(
            SearchResultsLoaded(
              users,
              users.length,
              users.where((user) => user.isAdmin).length,
            ),
          );
        } catch (e) {
          emit(SearchResultsError('Failed to load users: $e'));
        }
      } else if (event is SearchUsersQueryChangedEvent) {
        emit(SearchResultsLoading());
        try {
          final List<UserDataModel> filteredUsers = users
              .where(
                (user) =>
                    user.name.toLowerCase().contains(event.query) ||
                    user.email.toLowerCase().contains(event.query),
              )
              .toList();
          emit(
            SearchResultsLoaded(
              filteredUsers,
              users.length,
              users.where((user) => user.isAdmin).length,
            ),
          );
        } catch (e) {
          emit(SearchResultsError('Failed to search users: $e'));
        }
      } else if (event is RemoveAdminPermissionEvent) {
        emit(SearchResultsLoading());
        try {
          await AdminRepository.removeAdminPermission(event.user);
          emit(
            RequestSentState(
              'Request to remove admin permission sent for ${event.user.name}.',
            ),
          );
        } catch (e) {
          emit(SearchResultsError('Failed to remove admin permission: $e'));
        }
      } else if (event is AddAdminPermissionEvent) {
        emit(SearchResultsLoading());
        try {
          await AdminRepository.addAdminPermission(event.user);
          emit(
            RequestSentState(
              'Request to add admin permission sent for ${event.user.name}.',
            ),
          );
        } catch (e) {
          emit(SearchResultsError('Failed to add admin permission: $e'));
        }
      } else if (event is RefreshSearchUsersEvent) {
        emit(SearchResultsLoading());
        try {
          // Fetch all users from the database
          users = await AdminRepository.getAllUsers();
          emit(
            SearchResultsLoaded(
              users,
              users.length,
              users.where((user) => user.isAdmin).length,
            ),
          );
        } catch (e) {
          emit(SearchResultsError('Failed to load users: $e'));
        }
      }
    });
  }
}
