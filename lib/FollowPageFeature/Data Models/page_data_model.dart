import 'package:flutter/material.dart';

class PageDataModel {
  final int id;
  final String title; // Mapping to 'Type' or 'Title' based on your UI
  final String hall;
  final String instructor;
  final TimeOfDay startTime;
  final int courseId;
  bool isNotificationEnabled;
  bool isFollowed;

  PageDataModel({
    required this.id,
    required this.title,
    required this.hall,
    required this.instructor,
    required this.startTime,
    required this.courseId,
    this.isNotificationEnabled = false,
    this.isFollowed = false,
  });

  factory PageDataModel.fromMap(Map<String, dynamic> map) {
    return PageDataModel(
      id: map['id'] ?? '',
      title: map['type'] ?? '',
      hall: map['hall'] ?? '',
      instructor: map['instructors']['instructor_name'] ?? '',
      startTime: TimeOfDay(
        hour: map['start_time'] != null
            ? int.parse(map['start_time'].split(':')[0])
            : 0,
        minute: map['start_time'] != null
            ? int.parse(map['start_time'].split(':')[1])
            : 0,
      ),
      isFollowed: map['isFollowed'] ?? false,
      courseId: map['course_id'] ?? 0,
    );
  }
}
