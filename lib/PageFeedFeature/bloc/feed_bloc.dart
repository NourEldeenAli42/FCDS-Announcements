import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/AdminFeature/repositories/admin_repository.dart';
import 'package:fcds_announcements/PageFeedFeature/Data%20Models/announcement_data_model.dart';
import 'package:fcds_announcements/PageFeedFeature/Data%20Models/page_feed_data_model.dart';
import 'package:fcds_announcements/PageFeedFeature/repository/feed_repository.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedInitial()) {
    on<FeedEvent>((event, emit) async {
      if (event is LoadFeedPageEvent) {
        emit(FeedLoading());
        final announcements = await FeedRepository.fetchAnnouncements(
          event.pageId,
        );
        final page = await FeedRepository.fetchPage(event.pageId);
        final isNotificationEnabled =
            await FeedRepository.isNotificationEnabled(event.pageId);
        final adminStatus = await UserRepository.userHasPermission(
          event.pageId,
        );
        emit(
          FeedLoaded(
            announcements: announcements,
            page: page,
            isAdmin: adminStatus,
            isNotificationEnabled: isNotificationEnabled,
          ),
        );
      } else if (event is RefreshAnnouncementsEvent) {
        final announcements = await FeedRepository.fetchAnnouncements(
          event.pageId,
        );
        final isNotificationEnabled =
            await FeedRepository.isNotificationEnabled(event.pageId);
        final adminStatus = await UserRepository.userHasPermission(
          event.pageId,
        );
        emit(
          FeedLoaded(
            announcements: announcements,
            page: event.page,
            isAdmin: adminStatus,
            isNotificationEnabled: isNotificationEnabled,
          ),
        );
      } else if (event is DeleteAnnouncementEvent) {
        await AdminRepository.deleteAnnouncement(event.announcementId);
        final currentState = state;
        if (currentState is FeedLoaded) {
          final updatedAnnouncements = currentState.announcements
              .where((announcement) => announcement.id != event.announcementId)
              .toList();
          emit(
            FeedLoaded(
              announcements: updatedAnnouncements,
              page: currentState.page,
              isAdmin: currentState.isAdmin,
              isNotificationEnabled: currentState.isNotificationEnabled,
            ),
          );
        }
      } else if (event is EditAnnouncementEvent) {
        final currentState = state;
        await AdminRepository.editAnnouncement(
          announcement: event.announcement,
        );
        if (currentState is FeedLoaded) {
          final updatedAnnouncements = currentState.announcements.map((
            announcement,
          ) {
            if (announcement.id == event.announcement.id) {
              return event.announcement;
            }
            return announcement;
          }).toList();
          emit(
            FeedLoaded(
              announcements: updatedAnnouncements,
              page: currentState.page,
              isAdmin: currentState.isAdmin,
              isNotificationEnabled: currentState.isNotificationEnabled,
            ),
          );
        }
      } else if (event is ToggleNotificationEvent) {
        final currentState = state;
        if (currentState is FeedLoaded) {
          emit(
            FeedLoaded(
              announcements: currentState.announcements,
              page: currentState.page,
              isAdmin: currentState.isAdmin,
              isNotificationEnabled: currentState.isNotificationEnabled,
              isTogglingNotifications: true,
            ),
          );
          final newStatus = !currentState.isNotificationEnabled;
          await FeedRepository.flipNotificationStatus(pageId: event.pageId);
          emit(
            FeedLoaded(
              announcements: currentState.announcements,
              page: currentState.page,
              isAdmin: currentState.isAdmin,
              isNotificationEnabled: newStatus,
            ),
          );
        }
      }
    });
  }
}
