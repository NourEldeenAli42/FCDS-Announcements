import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PagesRepository {
  final supabase = Supabase.instance.client;
  Future<List<CourseDataModel>> fetchAllCourses() async {
    final response = await supabase.from('courses').select();
    return response.map((data) => CourseDataModel.fromDocument(data)).toList();
  }

  Future<List<PageDataModel>> fetchCourseSpecificPages(String courseId) async {
    final response = await supabase
        .from('pages')
        .select('*, instructors(instructor_name)')
        .eq('course_id', courseId);
    final followedPageIds = await UserRepository.getFollowedPageIds();

    return response.map((pageMap) {
      pageMap['instructorName'] = pageMap['instructors']?['name'];
      pageMap['isFollowed'] = followedPageIds.contains(pageMap['id']);
      return PageDataModel.fromMap(pageMap);
    }).toList();
  }

  Future<void> followPage({required String userId, required int pageID}) async {
    FirebaseMessaging.instance.subscribeToTopic(pageID.toString());

    final supabase = Supabase.instance.client;
    await supabase.from('follows').insert({
      'user_id': userId,
      'page_id': pageID,
    });
  }

  Future<void> unfollowPage({
    required String userId,
    required int pageID,
  }) async {
    FirebaseMessaging.instance.unsubscribeFromTopic(pageID.toString());
    final supabase = Supabase.instance.client;
    await supabase
        .from('follows')
        .delete()
        .eq('user_id', userId)
        .eq('page_id', pageID);
  }
}
