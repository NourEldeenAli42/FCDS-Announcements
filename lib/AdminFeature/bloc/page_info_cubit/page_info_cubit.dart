import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/AdminFeature/Data%20Models/instructor_data_model.dart';
import 'package:fcds_announcements/AdminFeature/repositories/admin_repository.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'page_info_state.dart';

class PageInfoCubit extends Cubit<PageInfoState> {
  PageInfoCubit() : super(PageInfoInitial());
  Future<void> fetchInstructors() async {
    emit(PageInfoLoading());
    try {
      final instructors = await AdminRepository.fetchInstructors();
      emit(PageInfoLoaded(instructors: instructors));
    } catch (e) {
      emit(PageInfoError(message: e.toString()));
    }
  }
  Future<void> savePageEdit(PageDataModel page) async  {
    emit(PageInfoLoading());
    try {
      await AdminRepository.editPage(page);
      emit(PageInfoLoaded(instructors: (state as PageInfoLoaded).instructors));
    } catch (e) {
      emit(PageInfoError(message: e.toString()));
    }
  }
}
