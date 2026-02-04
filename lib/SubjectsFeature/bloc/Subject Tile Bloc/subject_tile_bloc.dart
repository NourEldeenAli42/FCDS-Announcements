import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
import 'package:fcds_announcements/HomeFeature/Models/urgent_announcement_data_model.dart';
import 'package:fcds_announcements/SubjectsFeature/repositories/subjects_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'subject_tile_event.dart';
part 'subject_tile_state.dart';

class SubjectTileBloc extends Bloc<SubjectTileEvent, SubjectTileState> {
  SubjectTileBloc() : super(SubjectTileInitial()) {
    SubjectsRepository subjectsRepository = SubjectsRepository();
    on<SubjectTileEvent>((event, emit) async {
      if (event is LoadFollowedPagesofSubjectEvent) {
        emit(FollowedPagesLoading(subjectId: event.subjectId));
        try {
          final pages = await subjectsRepository.fetchFollowedPagesforSubject(
            event.subjectId,
          );
          final followedPageIds = pages.map((page) => page.id).toList();
          final urgentAnnouncement = await subjectsRepository.getUrgentAnnouncement(followedPageIds);
          emit(FollowedPagesLoaded(subjectId: event.subjectId, pages: pages, urgentAnnouncement: urgentAnnouncement));
        } catch (e) {
          emit(FollowedPagesError(message: e.toString()));
        }
      }
    });
  }
}
