import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcds_announcements/HomeFeature/Models/urgent_announcement_data_model.dart';

class UrgentAnnouncementRepository {
  final FirebaseFirestore _firestore;

  UrgentAnnouncementRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UrgentUpdateDataModel?> getUrgentAnnouncement(
    List<String> followedPageIds,
  ) async {
    if (followedPageIds.isEmpty) return null;

    final query = await _firestore
        .collection('announcements')
        .where('page_id', whereIn: followedPageIds)
        .where('isUrgent', isEqualTo: true)
        .orderBy('post_time', descending: true)
        .limit(1)
        .get();
    if (query.docs.isEmpty) {
      return null;
    }
    final announcement = UrgentUpdateDataModel.fromFirestore(
      query.docs.first.data(),
    );
    return announcement;
  }
}
