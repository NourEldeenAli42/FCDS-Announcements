part of 'function_buttons_bloc.dart';

sealed class FunctionButtonsEvent extends Equatable {
  const FunctionButtonsEvent();

  @override
  List<Object> get props => [];
}
class LoadReadFunctionButtonsEvent extends FunctionButtonsEvent {
  const LoadReadFunctionButtonsEvent();
}