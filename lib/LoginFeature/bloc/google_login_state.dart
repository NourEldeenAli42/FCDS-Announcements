part of 'google_login_bloc.dart';

sealed class GoogleLoginState extends Equatable {
  const GoogleLoginState();

  @override
  List<Object> get props => [];
}

final class GoogleLoginInitial extends GoogleLoginState {}

final class GoogleLoginInProgress extends GoogleLoginState {}

final class GoogleLoginSuccess extends GoogleLoginState {}

final class GoogleLoginFailure extends GoogleLoginState {
  final String errorMessage;

  const GoogleLoginFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
