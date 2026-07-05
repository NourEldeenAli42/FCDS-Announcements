import 'package:fcds_announcements/HomeFeature/Models/urgent_announcement_data_model.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UrgentAnnouncementRepository {
  static Future<UrgentUpdateDataModel?> getUrgentAnnouncement() async {
    final followedPageIds = await UserRepository.getFollowedPageIds();
    if (followedPageIds.isEmpty) return null;
    final supabase = Supabase.instance.client;
    final uniquePageIds = followedPageIds.toSet().toList();
    final response = await supabase
        .from('announcements')
        .select()
        .inFilter('page_id', uniquePageIds)
        .eq('is_urgent', true)
        .order('created_at', ascending: false)
        .limit(1);
    if (response.isEmpty) return null;
    final latestDoc = response.first;

    final announcement = UrgentUpdateDataModel.fromDocument(latestDoc);
    return announcement;
  }
}
