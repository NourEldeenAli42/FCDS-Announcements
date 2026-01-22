part of 'priority_deadline_bloc.dart';

sealed class PriorityDeadlineEvent extends Equatable {
  const PriorityDeadlineEvent();

  @override
  List<Object> get props => [];
}
class LoadPriorityDeadlineEvent extends PriorityDeadlineEvent {
  const LoadPriorityDeadlineEvent();
}

class LoadMorePriorityDeadlineEvent extends PriorityDeadlineEvent {
  const LoadMorePriorityDeadlineEvent();
}
class RefreshPriorityDeadlineEvent extends PriorityDeadlineEvent {
  const RefreshPriorityDeadlineEvent();
}