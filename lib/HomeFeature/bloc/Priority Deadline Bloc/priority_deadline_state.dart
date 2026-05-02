part of 'priority_deadline_bloc.dart';

sealed class PriorityDeadlineState extends Equatable {
  const PriorityDeadlineState();

  @override
  List<Object> get props => [];
}

final class PriorityDeadlineInitial extends PriorityDeadlineState {}

class PriorityDeadlineLoading extends PriorityDeadlineState {}

class PriorityDeadlineLoaded extends PriorityDeadlineState {
  final List<PriorityDeadlineDataModel> priorityDeadline;
  const PriorityDeadlineLoaded(this.priorityDeadline);
}
