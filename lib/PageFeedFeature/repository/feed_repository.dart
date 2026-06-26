import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcds_announcements/PageFeedFeature/Data%20Models/announcement_data_model.dart';

class FeedRepository {
  Future<List<AnnouncementDataModel>> fetchAnnouncements(int pageId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await db
        .collection('announcements')
        .where('page_id', isEqualTo: pageId)
        .orderBy('post_time', descending: true)
        .get();
    List<AnnouncementDataModel> announcements = [];
    for (var doc in snapshot.docs) {
      announcements.add(
        AnnouncementDataModel.fromMap(doc.data() as Map<String, dynamic>),
      );
    }
    return announcements;
  }
}
