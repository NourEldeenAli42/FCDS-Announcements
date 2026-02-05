part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}
final class ProfileLoading extends ProfileState {}
final class ProfileSuccess extends ProfileState {}
final class ProfileFailure extends ProfileState {
  final String error;
  const ProfileFailure(this.error);

  @override
  List<Object> get props => [error];
}