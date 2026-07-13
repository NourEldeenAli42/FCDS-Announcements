part of 'subject_tile_bloc.dart';

sealed class SubjectTileState extends Equatable {
  const SubjectTileState();

  @override
  List<Object> get props => [];
}

final class SubjectTileInitial extends SubjectTileState {}

class FollowedPagesLoading extends SubjectTileState {
  final int subjectId;

  const FollowedPagesLoading({required this.subjectId});

  @override
  List<Object> get props => [subjectId];
}

class FollowedPagesLoaded extends SubjectTileState {
  final int subjectId;
  final List<PageDataModel> pages;
  final UrgentUpdateDataModel? urgentAnnouncement;

  const FollowedPagesLoaded({
    required this.subjectId,
    required this.pages,
    this.urgentAnnouncement,
  });

  @override
  List<Object> get props => [subjectId, pages];
}

class FollowedPagesError extends SubjectTileState {
  final String message;

  const FollowedPagesError({required this.message});

  @override
  List<Object> get props => [message];
}
