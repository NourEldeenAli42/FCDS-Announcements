import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/HomeFeature/Models/priority_deadline_data_model.dart';
import 'package:fcds_announcements/HomeFeature/repositories/priority_deadline_repository.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'priority_deadline_event.dart';
part 'priority_deadline_state.dart';

class PriorityDeadlineBloc
    extends Bloc<PriorityDeadlineEvent, PriorityDeadlineState> {
  PriorityDeadlineRepository priorityDeadlineRepository =
      PriorityDeadlineRepository();
  UserRepository userRepository = UserRepository();
  PriorityDeadlineBloc() : super(PriorityDeadlineInitial()) {
    on<PriorityDeadlineEvent>((event, emit) async {
      if (event is LoadPriorityDeadlineEvent) {
        emit(PriorityDeadlineLoading());
        final followedPageIds = await userRepository.getFollowedPageIds();
        final priorityDeadline = await priorityDeadlineRepository
            .getPriorityDeadline(followedPageIds);
        emit(PriorityDeadlineLoaded(priorityDeadline));
      } else if (event is RefreshPriorityDeadlineEvent) {
        emit(PriorityDeadlineLoading());
        final followedPageIds = await userRepository.getFollowedPageIds();
        final priorityDeadline = await priorityDeadlineRepository
            .getPriorityDeadline(followedPageIds);
        emit(PriorityDeadlineLoaded(priorityDeadline));
      }
    });
  }
}
