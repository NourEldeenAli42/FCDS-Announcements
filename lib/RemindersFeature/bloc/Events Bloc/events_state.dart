part of 'events_bloc.dart';

sealed class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object> get props => [];
}

final class EventsInitial extends EventsState {}

class EventsLoadingState extends EventsState {}

class EventsLoadedState extends EventsState {
  final List<AnnouncementDataModel> events;
  final List<AnnouncementDataModel> selectedEvents;
  const EventsLoadedState({
    this.events = const [],
    this.selectedEvents = const [],
  });

  @override
  List<Object> get props => [events, selectedEvents];
}

class EventsErrorState extends EventsState {
  final String message;
  const EventsErrorState(this.message);
}
