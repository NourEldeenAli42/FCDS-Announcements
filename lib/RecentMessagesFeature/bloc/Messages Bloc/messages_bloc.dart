import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/RecentMessagesFeature/Data%20Models/notification_data_model.dart';
import 'package:fcds_announcements/RecentMessagesFeature/repositories/notification_reciever_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc() : super(MessagesInitial()) {
    NotificationRepository notificationRepository = NotificationRepository();
    on<MessagesEvent>((event, emit) async {
      if (event is LoadMessagesEvent) {
        return emit.forEach<List<NotificationItemDataModel>>(
          notificationRepository.watchAllNotifications(),
          onData: (messages) => MessagesLoaded(messages),
        );
      } else if (event is MarkAllMessagesAsReadEvent) {
        await notificationRepository.markAllAsRead();
      } else if (event is SearchMessagesEvent) {
        try {
          emit(MessagesLoading());
          final allMessages = await notificationRepository
              .getAllNotifications();
          final filteredMessages = allMessages.where((message) {
            final queryLower = event.query.toLowerCase();
            final titleLower = message.title?.toLowerCase() ?? '';
            final bodyLower = message.body?.toLowerCase() ?? '';
            return titleLower.contains(queryLower) ||
                bodyLower.contains(queryLower);
          }).toList();
          emit(MessagesLoaded(filteredMessages));
        } catch (e) {
          log('Error searching messages: $e');
          emit(MessagesError('Failed to search messages'));
        }
      } else if (event is MarkMessageAsReadEvent) {
        await notificationRepository.markSpecificasRead(event.messageId);
      }
      else if (event is DeleteMessageEvent) {
        await notificationRepository.deleteMessage(event.messageId);
      }
    });
  }
}
