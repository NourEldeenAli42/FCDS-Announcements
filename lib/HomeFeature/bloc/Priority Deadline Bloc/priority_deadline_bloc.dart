import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/HomeFeature/Models/priority_deadline_data_model.dart';
import 'package:fcds_announcements/HomeFeature/repositories/priority_deadline_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'priority_deadline_event.dart';
part 'priority_deadline_state.dart';

class PriorityDeadlineBloc
    extends Bloc<PriorityDeadlineEvent, PriorityDeadlineState> {
  PriorityDeadlineBloc() : super(PriorityDeadlineInitial()) {
    on<PriorityDeadlineEvent>((event, emit) async {
      if (event is LoadPriorityDeadlineEvent) {
        emit(PriorityDeadlineLoading());
        final priorityDeadline =
            await PriorityDeadlineRepository.getPriorityDeadline();
        emit(PriorityDeadlineLoaded(priorityDeadline));
      } else if (event is RefreshPriorityDeadlineEvent) {
        emit(PriorityDeadlineLoading());
        final priorityDeadline =
            await PriorityDeadlineRepository.getPriorityDeadline();
        emit(PriorityDeadlineLoaded(priorityDeadline));
      }
    });
  }
}
