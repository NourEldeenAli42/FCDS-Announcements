import 'package:fcds_announcements/HomeFeature/Models/priority_deadline_data_model.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PriorityDeadlineRepository {
  static Future<List<PriorityDeadlineDataModel>> getPriorityDeadline() async {
    final followedPageIds = await UserRepository.getFollowedPageIds();
    if (followedPageIds.isEmpty) return [];
    final uniquePageIds = followedPageIds.toSet().toList();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('announcements')
        .select()
        .inFilter('page_id', uniquePageIds)
        .gt('deadline', DateTime.now())
        .order('created_at', ascending: false);

    final allDeadlines = <PriorityDeadlineDataModel>[];
    for (final candidate in response) {
      allDeadlines.add(PriorityDeadlineDataModel.fromFirestore(candidate));
    }
    return allDeadlines;
  }
}
