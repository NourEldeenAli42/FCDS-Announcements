import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/FollowPageFeature/repositories/pages_repository.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'follow_page_state.dart';

class FollowPageCubit extends Cubit<FollowPageState> {
  UserRepository userRepository = UserRepository();
  PagesRepository pagesRepository = PagesRepository();
  final String pageID;

  FollowPageCubit(this.pageID) : super(FollowPageInitial()) {
    checkFollowed(pageID);
  }

  Future<void> checkFollowed(String pageID) async {
    emit(FollowPageLoading());
    final followedPageIds = await userRepository.getFollowedPageIds();
    bool isFollowed = followedPageIds.contains(pageID);
    if (isFollowed) {
      emit(FollowPageFollowed());
    } else {
      emit(FollowPageUnfollowed());
    }
  }

  Future<void> followPage(String pageID) async {
    emit(FollowPageLoading());
    try {
      await pagesRepository.followPage(
        userId: userRepository.user!.uid,
        pageName: pageID,
      );
    } catch (e) {
      emit(FollowPageUnfollowed());
      return;
    }
    emit(FollowPageFollowed());
  }

  Future<void> unfollowPage(String pageID) async {
    emit(FollowPageLoading());
    try {
      await pagesRepository.unfollowPage(
        userId: userRepository.user!.uid,
        pageName: pageID,
      );
    } catch (e) {
      emit(FollowPageFollowed());
      return;
    }
    emit(FollowPageUnfollowed());
  }
}
