part of 'update_pages_cubit.dart';

sealed class UpdatePagesState extends Equatable {
  const UpdatePagesState();

  @override
  List<Object> get props => [];
}

final class UpdatePagesInitial extends UpdatePagesState {}
final class UpdatePagesLoading extends UpdatePagesState {}
final class UpdatePagesSuccess extends UpdatePagesState {}
final class UpdatePagesError extends UpdatePagesState {
  final String message;
  const UpdatePagesError({required this.message});

  @override
  List<Object> get props => [message];
}