import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/PageFeedFeature/Data%20Models/announcement_data_model.dart';
import 'package:fcds_announcements/RemindersFeature/repository/events_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc() : super(EventsInitial()) {
    on<EventsEvent>((event, emit) async {
      if (event is LoadEventsEvent) {
        emit(EventsLoadingState());
        try {
          final events = await EventsRepository.fetchEvents();
          events.removeWhere((event) => event.deadline == null);

          // Select today's events by default
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final todaysEvents = events.where((event) {
            final deadline = event.deadline;
            if (deadline == null) return false;
            return deadline.year == today.year &&
                deadline.month == today.month &&
                deadline.day == today.day;
          }).toList();

          emit(EventsLoadedState(events: events, selectedEvents: todaysEvents));
        } catch (e) {
          emit(EventsErrorState('Failed to load events'));
        }
      } else if (event is SelectEventsEvent) {
        if (state is EventsLoadedState) {
          final currentState = state as EventsLoadedState;
          final eventDate = event.date;
          final eventList = currentState.events;
          final filteredEvents = eventList.where((event) {
            if (event.deadline == null) return false;
            final deadlineDate = event.deadline!;
            return deadlineDate.year == eventDate.year &&
                deadlineDate.month == eventDate.month &&
                deadlineDate.day == eventDate.day;
          }).toList();

          emit(
            EventsLoadedState(
              events: currentState.events,
              selectedEvents: filteredEvents,
            ),
          );
        }
      }
    });
  }
}
