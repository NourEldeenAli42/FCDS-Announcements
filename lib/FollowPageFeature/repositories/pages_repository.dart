import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';

class PagesRepository {
  final _db = FirebaseFirestore.instance;
  Future<List<CourseDataModel>> fetchAllCourses() async {
    final querySnapshot = await _db.collection('courses').get();
    return querySnapshot.docs
        .map((doc) => CourseDataModel.fromDocument(doc.data()))
        .toList();
  }

  Future<List<PageDataModel>> fetchCourseSpecificPages(
    String courseName,
  ) async {
    final querySnapshot = await _db
        .collection('courses')
        .where('CourseName', isEqualTo: courseName)
        .get();
    final data = querySnapshot.docs.first.data();
    final pagesData = data['Pages'] as List<dynamic>? ?? [];
    return pagesData.map((pageMap) => PageDataModel.fromMap(pageMap)).toList();
  }
}
