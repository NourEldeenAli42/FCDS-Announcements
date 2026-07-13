import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/HomeFeature/Models/urgent_announcement_data_model.dart';
import 'package:fcds_announcements/HomeFeature/repositories/urgent_update_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'announcement_event.dart';
part 'announcement_state.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  AnnouncementBloc() : super(AnnouncementInitial()) {
    on<AnnouncementEvent>((event, emit) async {
      if (event is LoadAnnouncementEvent) {
        emit(AnnouncementLoading());

        final announcement =
            await UrgentAnnouncementRepository.getUrgentAnnouncement();
        emit(AnnouncementLoaded(announcement));
      } else if (event is RefreshAnnouncementEvent) {
        emit(AnnouncementLoading());

        final announcement =
            await UrgentAnnouncementRepository.getUrgentAnnouncement();
        emit(AnnouncementLoaded(announcement));
      }
    });
  }
}
