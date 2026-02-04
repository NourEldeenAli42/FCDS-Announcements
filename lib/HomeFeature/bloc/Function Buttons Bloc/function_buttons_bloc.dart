import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/HomeFeature/repositories/read_check_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'function_buttons_event.dart';
part 'function_buttons_state.dart';

class FunctionButtonsBloc
    extends Bloc<FunctionButtonsEvent, FunctionButtonsState> {
  FunctionButtonsBloc() : super(FunctionButtonsInitial()) {
    on<FunctionButtonsEvent>((event, emit) async {
      ReadCheckRepository readCheckRepository = ReadCheckRepository();
      if (event is LoadReadFunctionButtonsEvent) {
        emit(FunctionButtonsReadLoading());
        await emit.forEach<bool>(
          readCheckRepository.hasUnreadMessages(),
          onData: (hasUnreadMessages) =>
              FunctionButtonsReadLoaded(hasUnreadMessages: hasUnreadMessages),
        );
      }
    });
  }
}
