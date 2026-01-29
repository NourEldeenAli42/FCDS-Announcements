import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/FollowPageFeature/repositories/pages_repository.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'follow_event.dart';
part 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  FollowBloc() : super(const FollowState()) {
    UserRepository userRepository = UserRepository();
    PagesRepository pagesRepository = PagesRepository();
    on<FollowEvent>((event, emit) async {
      if (event is FollowPageEvent) {
        // Update status to loading for this specific page
        final newStatuses = Map<String, PageFollowStatus>.from(
          state.pageStatuses,
        );
        newStatuses[event.pageName] = PageFollowStatus.loading;
        emit(state.copyWith(pageStatuses: newStatuses));

        try {
          final String userId = userRepository.user!.uid;
          if (event.isFollowed) {
            pagesRepository.unfollowPage(
              userId: userId,
              pageName: event.pageName,
            );
          }
          if (event.isFollowed == false) {
            pagesRepository.followPage(
              userId: userId,
              pageName: event.pageName,
            );
          }

          // Update status to success for this specific page
          final successStatuses = Map<String, PageFollowStatus>.from(
            state.pageStatuses,
          );
          successStatuses[event.pageName] = PageFollowStatus.success;
          emit(state.copyWith(pageStatuses: successStatuses));
        } catch (e) {
          // Update status to error for this specific page
          final errorStatuses = Map<String, PageFollowStatus>.from(
            state.pageStatuses,
          );
          errorStatuses[event.pageName] = PageFollowStatus.error;

          final errors = Map<String, String>.from(state.pageErrors);
          errors[event.pageName] = e.toString();

          emit(state.copyWith(pageStatuses: errorStatuses, pageErrors: errors));
        }
      }
    });
  }
}
