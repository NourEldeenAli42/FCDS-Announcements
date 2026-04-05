import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcds_announcements/HomeFeature/Models/priority_deadline_data_model.dart';

const int _firestoreFilterValueLimit = 30;

List<List<T>> _chunkList<T>(List<T> items, int chunkSize) {
  final chunks = <List<T>>[];
  for (int i = 0; i < items.length; i += chunkSize) {
    final end = (i + chunkSize < items.length) ? i + chunkSize : items.length;
    chunks.add(items.sublist(i, end));
  }
  return chunks;
}

class PriorityDeadlineRepository {
  final FirebaseFirestore _firestore;

  PriorityDeadlineRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<PriorityDeadlineDataModel?> getPriorityDeadline(
    List<String> followedPageIds,
  ) async {
    if (followedPageIds.isEmpty) return null;

    final uniquePageIds = followedPageIds.toSet().toList();
    QueryDocumentSnapshot<Map<String, dynamic>>? bestDoc;

    for (final pageChunk in _chunkList(
      uniquePageIds,
      _firestoreFilterValueLimit,
    )) {
      final query = await _firestore
          .collection('announcements')
          .where('page_id', whereIn: pageChunk)
          .orderBy('deadline', descending: false)
          .orderBy('post_time', descending: true)
          .where('deadline', isGreaterThan: Timestamp.now())
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        continue;
      }

      final candidate = query.docs.first;
      if (bestDoc == null) {
        bestDoc = candidate;
        continue;
      }

      final candidateDeadline = candidate.data()['deadline'] as Timestamp;
      final bestDeadline = bestDoc.data()['deadline'] as Timestamp;

      final isEarlierDeadline = candidateDeadline.toDate().isBefore(
        bestDeadline.toDate(),
      );
      final isSameDeadline = candidateDeadline.toDate().isAtSameMomentAs(
        bestDeadline.toDate(),
      );

      if (isEarlierDeadline) {
        bestDoc = candidate;
        continue;
      }

      if (isSameDeadline) {
        final candidatePostTime = candidate.data()['post_time'] as Timestamp;
        final bestPostTime = bestDoc.data()['post_time'] as Timestamp;
        if (candidatePostTime.toDate().isAfter(bestPostTime.toDate())) {
          bestDoc = candidate;
        }
      }
    }

    if (bestDoc == null) {
      return null;
    }

    final announcement = PriorityDeadlineDataModel.fromFirestore(
      bestDoc.data(),
    );
    return announcement;
  }
}
