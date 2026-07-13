import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/AdminFeature/repositories/admin_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_announcements_state.dart';

class AddAnnouncementsCubit extends Cubit<AddAnnouncementsCubitState> {
  AddAnnouncementsCubit() : super(AddAnnouncementsCubitInitial());
  Future<void> addUrgentAnnouncement({
    required String chipText,
    required String title,
    required String content,
    required bool notificationEnabled,
    required int pageId,
    required String redirectLink,
  }) async {
    emit(AddAnnouncementsCubitLoading());
    final result = await AdminRepository.addUrgentAnnouncement(
      chipText: chipText,
      title: title,
      content: content,
      notificationEnabled: notificationEnabled,
      pageId: pageId,
      redirectLink: redirectLink, // Pass the redirect link here
    );
    if (!result) {
      emit(AddAnnouncementsCubitError(message: 'Failed to add announcement.'));
      return;
    }
    emit(
      AddAnnouncementsCubitSuccess(message: 'Announcement added successfully!'),
    );
  }

  Future<void> addAnnouncement({
    required String title,
    required String content,
    required int pageId,
    required String redirectLink,
  }) async {
    emit(AddAnnouncementsCubitLoading());
    try {
      await AdminRepository.addAnnouncement(
        title: title,
        content: content,
        pageId: pageId,
        redirectLink: redirectLink, // Pass the redirect link here
      );

      emit(
        AddAnnouncementsCubitSuccess(
          message: 'Announcement added successfully!',
        ),
      );
    } catch (e) {
      emit(AddAnnouncementsCubitError(message: 'Failed to add announcement.'));
    }
  }

  Future<void> sendNotification({
    required String title,
    required String content,
    required int pageId,
  }) async {
    emit(AddAnnouncementsCubitLoading());
    try {
      await AdminRepository.sendNotification(
        title: title,
        content: content,
        pageId: pageId,
      );
      emit(
        AddAnnouncementsCubitSuccess(
          message: 'Notification sent successfully!',
        ),
      );
    } catch (e) {
      emit(AddAnnouncementsCubitError(message: 'Failed to send notification.'));
    }
  }
  Future<void> addPriorityDeadline({
    required String title,
    required DateTime deadline,
    required bool notificationEnabled,
    required int pageId,
  }) async {
    emit(AddAnnouncementsCubitLoading());
    try {
      await AdminRepository.addPriorityDeadline(
        title: title,
        deadline: deadline,
        pageId: pageId,
      );
      emit(
        AddAnnouncementsCubitSuccess(
          message: 'Priority deadline added successfully!',
        ),
      );
    } catch (e) {
      emit(AddAnnouncementsCubitError(message: 'Failed to add priority deadline.'));
    }
  }
}
