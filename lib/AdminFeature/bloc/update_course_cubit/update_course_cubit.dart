import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/AdminFeature/repositories/admin_repository.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'update_course_state.dart';

class UpdateCourseCubit extends Cubit<UpdateCourseState> {
  UpdateCourseCubit() : super(UpdateCourseInitial());
  Future<void> updateCourse(CourseDataModel course) async {
    emit(UpdateCourseLoading());
    try {
      await AdminRepository.updateCourse(course);
      emit(UpdateCourseSuccess());
    } catch (e) {
      emit(UpdateCourseError(e.toString()));
    }
  }

  Future<void> deleteCourse(int courseId) async {
    emit(UpdateCourseLoading());
    try {
      await AdminRepository.deleteCourse(courseId);
      emit(UpdateCourseSuccess());
    } catch (e) {
      emit(UpdateCourseError(e.toString()));
    }
  }

  Future<void> addCourse(CourseDataModel course) async {
    emit(UpdateCourseLoading());
    try {
      await AdminRepository.addCourse(course);
      emit(UpdateCourseSuccess());
    } catch (e) {
      log(e.toString());
      emit(UpdateCourseError(e.toString()));
    }
  }
}
