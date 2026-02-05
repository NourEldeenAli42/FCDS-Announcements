part of 'events_bloc.dart';

sealed class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

class LoadEventsEvent extends EventsEvent {
  const LoadEventsEvent();
}

class SelectEventsEvent extends EventsEvent {
  final DateTime date;
  const SelectEventsEvent(this.date);

  @override
  List<Object> get props => [date];
}
