import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcds_announcements/HomeFeature/Models/urgent_announcement_data_model.dart';

const int _firestoreFilterValueLimit = 30;

List<List<T>> _chunkList<T>(List<T> items, int chunkSize) {
  final chunks = <List<T>>[];
  for (int i = 0; i < items.length; i += chunkSize) {
    final end = (i + chunkSize < items.length) ? i + chunkSize : items.length;
    chunks.add(items.sublist(i, end));
  }
  return chunks;
}

class UrgentAnnouncementRepository {
  final FirebaseFirestore _firestore;

  UrgentAnnouncementRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UrgentUpdateDataModel?> getUrgentAnnouncement(
    List<String> followedPageIds,
  ) async {
    if (followedPageIds.isEmpty) return null;

    final uniquePageIds = followedPageIds.toSet().toList();
    QueryDocumentSnapshot<Map<String, dynamic>>? latestDoc;

    for (final pageChunk in _chunkList(
      uniquePageIds,
      _firestoreFilterValueLimit,
    )) {
      final query = await _firestore
          .collection('announcements')
          .where('page_id', whereIn: pageChunk)
          .where('isUrgent', isEqualTo: true)
          .orderBy('post_time', descending: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        continue;
      }

      final candidate = query.docs.first;
      if (latestDoc == null) {
        latestDoc = candidate;
        continue;
      }

      final candidateTimestamp = candidate.data()['post_time'] as Timestamp;
      final latestTimestamp = latestDoc.data()['post_time'] as Timestamp;
      if (candidateTimestamp.toDate().isAfter(latestTimestamp.toDate())) {
        latestDoc = candidate;
      }
    }

    if (latestDoc == null) {
      return null;
    }

    final announcement = UrgentUpdateDataModel.fromFirestore(latestDoc.data());
    return announcement;
  }
}
