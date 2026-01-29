import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/SubjectsFeature/repositories/subjects_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'subjects_event.dart';
part 'subjects_state.dart';

class SubjectsBloc extends Bloc<SubjectsEvent, SubjectsState> {
  SubjectsBloc() : super(SubjectsInitial()) {
    SubjectsRepository subjectsRepository = SubjectsRepository();
    on<SubjectsEvent>((event, emit) async {
      if (event is LoadSubjectsEvent) {
        emit(SubjectsLoading());
        try {
          final subjects = await subjectsRepository.fetchFollowedSubjects();
          emit(SubjectsLoaded(subjects: subjects));
        } catch (e) {
          emit(SubjectsError(message: e.toString()));
        }
      }
    });
  }
}
