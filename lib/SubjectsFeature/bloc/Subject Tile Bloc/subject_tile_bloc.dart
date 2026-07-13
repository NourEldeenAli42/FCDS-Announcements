import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/repositories/pages_repository.dart';
import 'package:fcds_announcements/HomeFeature/Models/urgent_announcement_data_model.dart';
import 'package:fcds_announcements/SubjectsFeature/repositories/subjects_repository.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'subject_tile_event.dart';
part 'subject_tile_state.dart';

class SubjectTileBloc extends Bloc<SubjectTileEvent, SubjectTileState> {
  SubjectTileBloc() : super(SubjectTileInitial()) {
    SubjectsRepository subjectsRepository = SubjectsRepository();
    PagesRepository pagesRepository = PagesRepository();
    on<SubjectTileEvent>((event, emit) async {
      if (event is LoadFollowedPagesofSubjectEvent) {
        emit(FollowedPagesLoading(subjectId: event.subjectId));
        try {
          List<PageDataModel> pages = await pagesRepository
              .fetchCourseSpecificPages(event.subjectId);
          final followedPageIds = await UserRepository.getFollowedPageIds();
          final List<PageDataModel> returnedPages = [];
          for (final page in pages) {
            if (followedPageIds.contains(page.id)) {
              returnedPages.add(page);
            }
          }
          final urgentAnnouncement = await subjectsRepository
              .getUrgentAnnouncementForSubject(event.subjectId);
          emit(
            FollowedPagesLoaded(
              subjectId: event.subjectId,
              pages: returnedPages,
              urgentAnnouncement: urgentAnnouncement,
            ),
          );
        } catch (e) {
          emit(FollowedPagesError(message: e.toString()));
        }
      }
    });
  }
}
