part of 'messages_bloc.dart';

sealed class MessagesState extends Equatable {
  const MessagesState();
  
  @override
  List<Object> get props => [];
}

final class MessagesInitial extends MessagesState {}
final class MessagesLoading extends MessagesState {}
final class MessagesLoaded extends MessagesState {
  final List<NotificationItemDataModel> messages;
  const MessagesLoaded(this.messages);
  @override
  List<Object> get props => [messages];
}
final class MessagesError extends MessagesState {
  final String error;
  const MessagesError(this.error);
  @override
  List<Object> get props => [error];
}
