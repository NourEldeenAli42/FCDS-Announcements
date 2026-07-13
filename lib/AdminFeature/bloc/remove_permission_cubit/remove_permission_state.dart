part of 'remove_permission_cubit.dart';

sealed class RemovePermissionState extends Equatable {
  const RemovePermissionState();

  @override
  List<Object> get props => [];
}

final class RemovePermissionInitial extends RemovePermissionState {}

final class RemovePermissionLoading extends RemovePermissionState {}

final class RemovePermissionSuccess extends RemovePermissionState {}

final class RemovePermissionError extends RemovePermissionState {
  final String message;
  const RemovePermissionError(this.message);

  @override
  List<Object> get props => [message];
}
