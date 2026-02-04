import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/RemindersFeature/Data%20Models/reminder_data_model.dart';
import 'package:fcds_announcements/RemindersFeature/repository/reminders_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'reminders_event.dart';
part 'reminders_state.dart';

class RemindersBloc extends Bloc<RemindersEvent, RemindersState> {
  RemindersRepository remindersRepository = RemindersRepository();
  RemindersBloc() : super(RemindersInitial()) {
    on<RemindersEvent>((event, emit) async {
      if (event is LoadRemindersEvent) {
        emit(RemindersLoadingState());
        final reminders = await remindersRepository.getPendingReminders();
        emit(RemindersLoadedState(reminders));
      }
    });
  }
}
