import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
    UserRepository userRepository = UserRepository();
    final followedPageIds = await userRepository.getFollowedPageIds();
    return pagesData.map((pageMap) {
      pageMap['isFollowed'] = followedPageIds.contains(pageMap['id']);
      return PageDataModel.fromMap(pageMap);
    }).toList();
  }

  Future<void> followPage({
    required String userId,
    required String pageName,
  }) async {
    FirebaseMessaging.instance.subscribeToTopic(pageName);
    final userRef = _db.collection('users').doc(userId);

    await userRef.update({
      'following': FieldValue.arrayUnion([pageName]),
    });
  }

  Future<void> unfollowPage({
    required String userId,
    required String pageName,
  }) async {
    FirebaseMessaging.instance.unsubscribeFromTopic(pageName);
    final userRef = _db.collection('users').doc(userId);

    await userRef.update({
      'following': FieldValue.arrayRemove([pageName]),
    });
  }
}
