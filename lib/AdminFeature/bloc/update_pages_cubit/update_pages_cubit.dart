
import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/AdminFeature/repositories/admin_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'update_pages_state.dart';

class UpdatePagesCubit extends Cubit<UpdatePagesState> {
  UpdatePagesCubit() : super(UpdatePagesInitial());
  Future<void> deletePage(int pageId) async {
    emit(UpdatePagesLoading());
    try {
      await AdminRepository.deletePage(pageId);
      emit(UpdatePagesSuccess());
    } catch (e) {
      emit(UpdatePagesError(message: e.toString()));
    }
  }
}
