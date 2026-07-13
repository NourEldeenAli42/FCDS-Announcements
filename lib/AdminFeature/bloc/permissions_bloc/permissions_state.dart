part of 'permissions_bloc.dart';

sealed class PermissionsState extends Equatable {
  const PermissionsState();
  
  @override
  List<Object> get props => [];
}

final class PermissionsInitial extends PermissionsState {}

final class PermissionsLoading extends PermissionsState {}

final class PermissionsLoaded extends PermissionsState {
  final List<PageDataModel> pagesWithPermissions;

  const PermissionsLoaded(this.pagesWithPermissions);

  @override
  List<Object> get props => [pagesWithPermissions];
}
final class PermissionsError extends PermissionsState {
  final String message;

  const PermissionsError(this.message);

  @override
  List<Object> get props => [message];
}