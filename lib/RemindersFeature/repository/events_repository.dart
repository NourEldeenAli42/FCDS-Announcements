import 'package:fcds_announcements/PageFeedFeature/Data%20Models/announcement_data_model.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventsRepository {
  static Future<List<AnnouncementDataModel>> fetchEvents() async {
    final followedPageIds = await UserRepository.getFollowedPageIds();
    if (followedPageIds.isEmpty) return [];
    final uniquePageIds = followedPageIds.toSet().toList();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('announcements')
        .select()
        .inFilter('page_id', uniquePageIds)
        .not('deadline', 'is', null)
        .order('created_at', ascending: false);

    final events = <AnnouncementDataModel>[];
    for (final doc in response) {
      events.add(AnnouncementDataModel.fromMap(doc));
    }
    return events;
  }
}
