part of 'add_permission_cubit.dart';

sealed class AddPermissionState extends Equatable {
  const AddPermissionState();

  @override
  List<Object> get props => [];
}

final class AddPermissionInitial extends AddPermissionState {}

final class AddPermissionLoading extends AddPermissionState {}

final class AddPermissionSuccess extends AddPermissionState {}

final class AddPermissionError extends AddPermissionState {
  final String message;
  const AddPermissionError(this.message);
  @override
  List<Object> get props => [message];
}
