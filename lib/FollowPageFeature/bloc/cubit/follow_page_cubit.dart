import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/FollowPageFeature/repositories/pages_repository.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'follow_page_state.dart';

class FollowPageCubit extends Cubit<FollowPageState> {
  PagesRepository pagesRepository = PagesRepository();
  final int pageID;

  FollowPageCubit({this.pageID = 0}) : super(FollowPageInitial()) {
    checkFollowed(pageID);
  }

  Future<void> checkFollowed(int pageID) async {
    emit(FollowPageLoading());
    final followedPageIds = await UserRepository.getFollowedPageIds();
    bool isFollowed = followedPageIds.contains(pageID);
    if (isFollowed) {
      emit(FollowPageFollowed());
    } else {
      emit(FollowPageUnfollowed());
    }
  }

  Future<void> followPage(int pageID) async {
    emit(FollowPageLoading());
    try {
      await pagesRepository.followPage(
        userId: UserRepository.supuser!.id,
        pageID: pageID,
      );
    } catch (e) {
      log('Error following page: $e');
      emit(FollowPageUnfollowed());
      return;
    }
    emit(FollowPageFollowed());
  }

  Future<void> unfollowPage(int pageID) async {
    emit(FollowPageLoading());
    try {
      await pagesRepository.unfollowPage(
        userId: UserRepository.supuser!.id,
        pageID: pageID,
      );
    } catch (e) {
      emit(FollowPageFollowed());
      return;
    }
    emit(FollowPageUnfollowed());
  }
}
