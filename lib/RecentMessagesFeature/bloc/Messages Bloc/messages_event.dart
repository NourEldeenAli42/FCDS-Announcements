part of 'messages_bloc.dart';

sealed class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object> get props => [];
}
class LoadMessagesEvent extends MessagesEvent {
  const LoadMessagesEvent();
}
class MarkAllMessagesAsReadEvent extends MessagesEvent {
  const MarkAllMessagesAsReadEvent();
}
class SearchMessagesEvent extends MessagesEvent {
  final String query;
  const SearchMessagesEvent(this.query);
  @override
  List<Object> get props => [query];
}
class MarkMessageAsReadEvent extends MessagesEvent {
  final int messageId;
  const MarkMessageAsReadEvent(this.messageId);
  @override
  List<Object> get props => [messageId];
}
class DeleteMessageEvent extends MessagesEvent {
  final int messageId;
  const DeleteMessageEvent(this.messageId);
  @override
  List<Object> get props => [messageId];
}