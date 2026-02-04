part of 'reminders_bloc.dart';

sealed class RemindersEvent extends Equatable {
  const RemindersEvent();

  @override
  List<Object> get props => [];
}

final class LoadRemindersEvent extends RemindersEvent {
  const LoadRemindersEvent();

  @override
  List<Object> get props => [];
}