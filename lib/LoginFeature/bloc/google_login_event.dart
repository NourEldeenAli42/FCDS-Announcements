part of 'google_login_bloc.dart';

sealed class GoogleLoginEvent extends Equatable {
  const GoogleLoginEvent();

  @override
  List<Object> get props => [];
}

final class GoogleLoginRequested extends GoogleLoginEvent {}

final class GoogleLogoutRequested extends GoogleLoginEvent {}