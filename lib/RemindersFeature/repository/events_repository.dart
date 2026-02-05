import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcds_announcements/PageFeedFeature/Data%20Models/announcement_data_model.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';

class EventsRepository {
  final db = FirebaseFirestore.instance;
  Future<List<AnnouncementDataModel>> fetchEvents() async {
    try {
      UserRepository userRepo = UserRepository();
      final followedPages = await userRepo.getFollowedPageIds();
      final snapshot = await db
          .collection('announcements')
          .where('page_id', whereIn: followedPages)
          .get();
      return snapshot.docs
          .map((doc) => AnnouncementDataModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }
}
