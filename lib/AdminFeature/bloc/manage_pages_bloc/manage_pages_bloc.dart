import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/AdminFeature/repositories/admin_repository.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manage_pages_event.dart';
part 'manage_pages_state.dart';

class ManagePagesBloc extends Bloc<ManagePagesEvent, ManagePagesState> {
  ManagePagesBloc() : super(ManagePagesInitial()) {
    on<ManagePagesEvent>((event, emit) async {
      if (event is LoadPagesEvent) {
        emit(ManagePagesLoading());
        try {
          final pages = await AdminRepository.loadPages();
          log('Loaded pages: $pages');
          emit(ManagePagesLoaded(pages: pages));
        } catch (e) {
          emit(ManagePagesError(message: e.toString()));
        }
      } else if (event is DeletePageEvent) {
        emit(ManagePagesLoading());
        try {
          await AdminRepository.deletePage(event.pageId);
          final pages = await AdminRepository.loadPages();
          log('Deleted page with ID: ${event.pageId}');
          emit(ManagePagesLoaded(pages: pages));
        } catch (e) {
          emit(ManagePagesError(message: e.toString()));
        }
      } else if (event is RefreshPagesEvent) {
        emit(ManagePagesLoading());
        try {
          final pages = await AdminRepository.loadPages();
          log('Refreshed pages: $pages');
          emit(ManagePagesLoaded(pages: pages));
        } catch (e) {
          emit(ManagePagesError(message: e.toString()));
        }
      }
    });
  }
}
