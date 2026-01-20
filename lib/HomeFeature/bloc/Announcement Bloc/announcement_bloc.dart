import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/HomeFeature/Models/urgent_announcement_data_model.dart';
import 'package:fcds_announcements/HomeFeature/repositories/urgent_update_reposittory.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'announcement_event.dart';
part 'announcement_state.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final UrgentAnnouncementRepository _repository =
      UrgentAnnouncementRepository();
  final _userRepository = UserRepository();
  AnnouncementBloc() : super(AnnouncementInitial()) {
    on<AnnouncementEvent>((event, emit) async {
      if (event is LoadAnnouncementEvent) {
        emit(AnnouncementLoading());

        final announcement = await _repository.getUrgentAnnouncement(
          await _userRepository.getFollowedPageIds(),
        );
        emit(AnnouncementLoaded(announcement));
      } else if (event is RefreshAnnouncementEvent) {
        emit(AnnouncementLoading());

        final announcement = await _repository.getUrgentAnnouncement(
          await _userRepository.getFollowedPageIds(),
        );
        emit(AnnouncementLoaded(announcement));
      }
    });
  }
}
