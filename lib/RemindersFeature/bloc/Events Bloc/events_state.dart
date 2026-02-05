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
  const EventsLoadedState(this.events);
}
class EventsErrorState extends EventsState {
  final String message;
  const EventsErrorState(this.message);
}