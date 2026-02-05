import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/PageFeedFeature/Data%20Models/announcement_data_model.dart';
import 'package:fcds_announcements/RemindersFeature/repository/events_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc() : super(EventsInitial()) {
    EventsRepository repository = EventsRepository();
    on<EventsEvent>((event, emit) async {
      if (event is LoadEventsEvent) {
        emit(EventsLoadingState());
        try {
          final events = await repository.fetchEvents();
          events.removeWhere((event) => event.deadline == null);
          log('Fetched ${events.length} events with deadlines');
          emit(EventsLoadedState(events));
        } catch (e) {
          emit(EventsErrorState('Failed to load events'));
        }
      }
    });
  }
}
