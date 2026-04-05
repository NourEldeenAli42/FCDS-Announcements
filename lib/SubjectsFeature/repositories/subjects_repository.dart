import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
import 'package:fcds_announcements/HomeFeature/Models/urgent_announcement_data_model.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';

const int _firestoreFilterValueLimit = 30;

List<List<T>> _chunkList<T>(List<T> items, int chunkSize) {
  final chunks = <List<T>>[];
  for (int i = 0; i < items.length; i += chunkSize) {
    final end = (i + chunkSize < items.length) ? i + chunkSize : items.length;
    chunks.add(items.sublist(i, end));
  }
  return chunks;
}

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
    if (followedPages.isEmpty) {
      return [];
    }

    final uniquePageIds = followedPages.toSet().toList();
    final coursesById = <String, Map<String, dynamic>>{};

    for (final pageChunk in _chunkList(
      uniquePageIds,
      _firestoreFilterValueLimit,
    )) {
      final querySnapshot = await _db
          .collection('courses')
          .where('pageIds', arrayContainsAny: pageChunk)
          .get();

      for (final doc in querySnapshot.docs) {
        coursesById[doc.id] = doc.data();
      }
    }

    return coursesById.values
        .map((doc) => CourseDataModel.fromDocument(doc))
        .toList();
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

    final uniquePageIds = followedPageIds.toSet().toList();
    QueryDocumentSnapshot<Map<String, dynamic>>? latestDoc;

    for (final pageChunk in _chunkList(
      uniquePageIds,
      _firestoreFilterValueLimit,
    )) {
      final query = await _db
          .collection('announcements')
          .where('page_id', whereIn: pageChunk)
          .where('isUrgent', isEqualTo: true)
          .orderBy('post_time', descending: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        continue;
      }

      final candidate = query.docs.first;
      if (latestDoc == null) {
        latestDoc = candidate;
        continue;
      }

      final candidateTimestamp = candidate.data()['post_time'] as Timestamp;
      final latestTimestamp = latestDoc.data()['post_time'] as Timestamp;

      if (candidateTimestamp.toDate().isAfter(latestTimestamp.toDate())) {
        latestDoc = candidate;
      }
    }

    if (latestDoc == null) {
      return null;
    }

    final announcement = UrgentUpdateDataModel.fromFirestore(latestDoc.data());
    return announcement;
  }
}
