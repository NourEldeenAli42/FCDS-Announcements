import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/AdminFeature/repositories/admin_repository.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_permission_state.dart';

class AddPermissionCubit extends Cubit<AddPermissionState> {
  AddPermissionCubit() : super(AddPermissionInitial());
  Future<void> addPermission(String userId, int pageId) async {
    emit(AddPermissionLoading());
    try {
      await AdminRepository.addPermissions(userId, pageId);
      emit(AddPermissionSuccess());
    } catch (e) {
      emit(AddPermissionError(e.toString()));
    }
  }

  Future<void> addPermissions(String userId, List<PageDataModel> pages) async {
    emit(AddPermissionLoading());
    try {
      for (final page in pages) {
        await AdminRepository.addPermissions(userId, page.id);
      }
      emit(AddPermissionSuccess());
    } catch (e) {
      emit(AddPermissionError(e.toString()));
    }
  }
}
