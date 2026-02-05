import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/ProfileFeature/repositories/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    ProfileRepository profileRepository = ProfileRepository();
    on<ProfileEvent>((event, emit) async {
      if (event is UpdateProfile) {
        emit(ProfileLoading());
        await profileRepository.updateProfile(event.name);
        emit(ProfileSuccess());
      } else if (event is RefreshProfileEvent) {
        emit(ProfileInitial());
      }
    });
  }
}
