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
    final tempIds = [];
    for (final course in response) {
      if (tempIds.contains(course['course_id'])) {
        continue;
      }
      coursesById.add(CourseDataModel.fromDocument(course['courses']));
      tempIds.add(course['course_id']);
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

  Future<UrgentUpdateDataModel?> getUrgentAnnouncementForSubject(
    int subjectId,
  ) async {
    final supabase = Supabase.instance.client;

    final followedPages = await UserRepository.getFollowedPageIds();
    if (followedPages.isEmpty) {
      return null;
    }

    final pagesResponse = await supabase
        .from('pages')
        .select('id')
        .eq('course_id', subjectId)
        .inFilter('id', followedPages);

    final pageIdsForSubject = pagesResponse
        .map((page) => page['id'] as int)
        .toList();

    if (pageIdsForSubject.isEmpty) {
      return null;
    }

    final latestDoc = await supabase
        .from('announcements')
        .select()
        .inFilter('page_id', pageIdsForSubject)
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
