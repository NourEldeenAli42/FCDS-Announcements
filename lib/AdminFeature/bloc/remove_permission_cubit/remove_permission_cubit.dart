
import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/AdminFeature/repositories/admin_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'remove_permission_state.dart';

class RemovePermissionCubit extends Cubit<RemovePermissionState> {
  RemovePermissionCubit() : super(RemovePermissionInitial());
  Future<void> removePermission(String userId, int pageId) async {
    emit(RemovePermissionLoading());
    try {
      await AdminRepository.removePermissions(userId, pageId);
      emit(RemovePermissionSuccess());
    } catch (e) {
      emit(RemovePermissionError(e.toString()));
    }
  }
}
