import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/HomeFeature/Models/urgent_announcement_data_model.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubjectsRepository {
  Future<List<CourseDataModel>> fetchFollowedSubjects() async {
    final followedPages = await UserRepository.getFollowedPageIds();
    if (followedPages.isEmpty) {
      return [];
    }

    final supabase = Supabase.instance.client;

    final uniquePageIds = followedPages.toSet().toList();
    final List<CourseDataModel> coursesById = [];

    final response = await supabase
        .from('pages')
        .select('course_id, courses(*)')
        .inFilter('id', uniquePageIds);
    final temp_ids = [];
    for (final course in response) {
      if (temp_ids.contains(course['id'])) {
        continue;
      }
      coursesById.add(CourseDataModel.fromDocument(course['courses']));
      temp_ids.add(course['id']);
    }
    return coursesById;
  }

  Future<UrgentUpdateDataModel?> getUrgentAnnouncement(
    List<int> followedPageIds,
  ) async {
    if (followedPageIds.isEmpty) return null;

    final supabase = Supabase.instance.client;

    final latestDoc = await supabase
        .from('announcements')
        .select()
        .inFilter('page_id', followedPageIds)
        .eq('is_urgent', true)
        .order('created_at', ascending: false)
        .limit(1);

    if (latestDoc.isEmpty) {
      return null;
    }

    final announcement = UrgentUpdateDataModel.fromDocument(latestDoc.first);
    return announcement;
  }
}
