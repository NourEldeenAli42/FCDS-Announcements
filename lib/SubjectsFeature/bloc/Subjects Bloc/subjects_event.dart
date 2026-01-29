part of 'subjects_bloc.dart';

sealed class SubjectsEvent extends Equatable {
  const SubjectsEvent();

  @override
  List<Object> get props => [];
}

class LoadSubjectsEvent extends SubjectsEvent {
  const LoadSubjectsEvent();

  @override
  List<Object> get props => [];
}
