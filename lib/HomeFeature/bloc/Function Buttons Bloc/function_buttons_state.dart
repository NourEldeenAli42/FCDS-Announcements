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
  final bool isAdmin;
  const FunctionButtonsReadLoaded({this.hasUnreadMessages = false, this.isAdmin = false});

  @override
  List<Object> get props => [hasUnreadMessages];
}
