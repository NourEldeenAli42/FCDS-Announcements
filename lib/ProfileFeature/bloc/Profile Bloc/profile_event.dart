part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}
class UpdateProfile extends ProfileEvent {
  final String name;
  const UpdateProfile(this.name);

  @override
  List<Object> get props => [name];
}
class RefreshProfileEvent extends ProfileEvent {}