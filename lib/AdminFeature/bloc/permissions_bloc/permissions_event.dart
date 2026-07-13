part of 'permissions_bloc.dart';

sealed class PermissionsEvent extends Equatable {
  const PermissionsEvent();

  @override
  List<Object> get props => [];
}

class LoadPermissionsEvent extends PermissionsEvent {
  final String userId;
  const LoadPermissionsEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}
