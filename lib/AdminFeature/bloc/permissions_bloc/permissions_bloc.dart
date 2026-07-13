
import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/AdminFeature/repositories/admin_repository.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  PermissionsBloc() : super(PermissionsInitial()) {
    on<PermissionsEvent>((event, emit) async {
      if (event is LoadPermissionsEvent) {
        emit(PermissionsLoading());
        try {
          final pagesWithPermissions =
              await AdminRepository.getPagesWithPermissions(event.userId);
          emit(PermissionsLoaded(pagesWithPermissions));
        } catch (e) {
          emit(PermissionsError(e.toString()));
        }
      }
    });
  }
}
