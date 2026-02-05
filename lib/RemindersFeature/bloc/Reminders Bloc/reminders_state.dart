part of 'reminders_bloc.dart';

sealed class RemindersState extends Equatable {
  const RemindersState();

  @override
  List<Object> get props => [];
}

final class RemindersInitial extends RemindersState {}

final class RemindersLoadingState extends RemindersState {}

final class RemindersLoadedState extends RemindersState {
  final List<Reminder> reminders;

  const RemindersLoadedState(this.reminders);

  @override
  List<Object> get props => [reminders];
}

final class RemindersErrorState extends RemindersState {
  final String message;

  const RemindersErrorState(this.message);

  @override
  List<Object> get props => [message];
}

final class AddingReminderState extends RemindersState {}
