part of 'events_bloc.dart';

sealed class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}
class LoadEventsEvent extends EventsEvent {
  const LoadEventsEvent();
}