import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
import 'package:fcds_announcements/HomeFeature/Models/urgent_announcement_data_model.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';

class SubjectsRepository {
  final _db = FirebaseFirestore.instance;
  Future<List<CourseDataModel>> fetchFollowedPages() async {
    final querySnapshot = await _db.collection('courses').get();
    return querySnapshot.docs
        .map((doc) => CourseDataModel.fromDocument(doc.data()))
        .toList();
  }

  Future<List<CourseDataModel>> fetchFollowedSubjects() async {
    UserRepository userRepository = UserRepository();
    final followedPages = await userRepository.getFollowedPageIds();
    followedPages.isEmpty ? followedPages.add('') : null;
    final querySnapshot = await _db
        .collection('courses')
        .where('pageIds', arrayContainsAny: followedPages)
        .get();

    final result = querySnapshot.docs
        .map((doc) => CourseDataModel.fromDocument(doc.data()))
        .toList();
    return result;
  }

  Future<List<PageDataModel>> fetchFollowedPagesforSubject(
    String subjectId,
  ) async {
    UserRepository userRepository = UserRepository();
    final followedPages = await userRepository.getFollowedPageIds();
    final querySnapshot = await _db.collection('courses').doc(subjectId).get();
    final courseData = querySnapshot.data()!['Pages'];
    List<PageDataModel> pages = [];
    for (var pageId in courseData) {
      if (followedPages.contains(pageId['id'])) {
        pages.add(PageDataModel.fromMap(pageId));
      }
    }
    return pages;
  }
  Future<UrgentUpdateDataModel?> getUrgentAnnouncement(
    List<String> followedPageIds,
  ) async {
    if (followedPageIds.isEmpty) return null;

    final query = await _db
        .collection('announcements')
        .where('page_id', whereIn: followedPageIds)
        .where('isUrgent', isEqualTo: true)
        .orderBy('post_time', descending: true)
        .limit(1)
        .get();
    if (query.docs.isEmpty) {
      return null;
    }
    final announcement = UrgentUpdateDataModel.fromFirestore(
      query.docs.first.data(),
    );
    return announcement;
  }
}
