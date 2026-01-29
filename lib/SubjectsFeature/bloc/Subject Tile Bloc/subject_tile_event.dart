part of 'subject_tile_bloc.dart';

sealed class SubjectTileEvent extends Equatable {
  const SubjectTileEvent();

  @override
  List<Object> get props => [];
}
class LoadFollowedPagesofSubjectEvent extends SubjectTileEvent {
  final String subjectId;

  const LoadFollowedPagesofSubjectEvent({required this.subjectId});

  @override
  List<Object> get props => [subjectId];
}