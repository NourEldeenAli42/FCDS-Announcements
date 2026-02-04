part of 'function_buttons_bloc.dart';

sealed class FunctionButtonsState extends Equatable {
  const FunctionButtonsState();

  @override
  List<Object> get props => [];
}

final class FunctionButtonsInitial extends FunctionButtonsState {}

final class FunctionButtonsReadLoading extends FunctionButtonsState {}

final class FunctionButtonsReadLoaded extends FunctionButtonsState {
  final bool hasUnreadMessages;
  final bool hasUnreadMaterials = false;
  const FunctionButtonsReadLoaded({this.hasUnreadMessages = false});

  @override
  List<Object> get props => [hasUnreadMessages];
}
