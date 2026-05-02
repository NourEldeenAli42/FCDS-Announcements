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
  final List<PriorityDeadlineDataModel> allDeadlines = [];
  Future<List<PriorityDeadlineDataModel>> getPriorityDeadline(
    List<String> followedPageIds,
  ) async {
    if (followedPageIds.isEmpty) return [];

    final uniquePageIds = followedPageIds.toSet().toList();

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
          .get();

      if (query.docs.isEmpty) {
        continue;
      }

      for (final candidate in query.docs) {
        allDeadlines.add(
          PriorityDeadlineDataModel.fromFirestore(candidate.data()),
        );
      }
      return allDeadlines;
    }
    return allDeadlines;
  }
}
