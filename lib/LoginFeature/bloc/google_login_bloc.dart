import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/LoginFeature/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'google_login_event.dart';
part 'google_login_state.dart';

class GoogleLoginBloc extends Bloc<GoogleLoginEvent, GoogleLoginState> {
  final AuthRepository authRepository;
  GoogleLoginBloc({required this.authRepository})
    : super(GoogleLoginInitial()) {
    on<GoogleLoginEvent>((event, emit) async {
      if (event is GoogleLoginRequested) {
        emit(GoogleLoginInProgress());
        try {
          await authRepository.nativeGoogleSignIn();
          emit(GoogleLoginSuccess());
        } catch (error) {
          log('GoogleLoginBloc: Error during Google sign-in: $error');
          emit(GoogleLoginFailure(error.toString()));
        }
      } else if (event is GoogleLogoutRequested) {
        // Handle Google logout logic here
        emit(GoogleLoginInitial());
      }
    });
  }
}
