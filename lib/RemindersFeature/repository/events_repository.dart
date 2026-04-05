import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcds_announcements/PageFeedFeature/Data%20Models/announcement_data_model.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';

const int _firestoreFilterValueLimit = 30;

List<List<T>> _chunkList<T>(List<T> items, int chunkSize) {
  final chunks = <List<T>>[];
  for (int i = 0; i < items.length; i += chunkSize) {
    final end = (i + chunkSize < items.length) ? i + chunkSize : items.length;
    chunks.add(items.sublist(i, end));
  }
  return chunks;
}

class EventsRepository {
  final db = FirebaseFirestore.instance;
  Future<List<AnnouncementDataModel>> fetchEvents() async {
    try {
      UserRepository userRepo = UserRepository();
      final followedPages = await userRepo.getFollowedPageIds();
      if (followedPages.isEmpty) {
        return [];
      }

      final uniquePageIds = followedPages.toSet().toList();
      final announcementsById = <String, Map<String, dynamic>>{};

      for (final pageChunk in _chunkList(
        uniquePageIds,
        _firestoreFilterValueLimit,
      )) {
        final snapshot = await db
            .collection('announcements')
            .where('page_id', whereIn: pageChunk)
            .get();

        for (final doc in snapshot.docs) {
          announcementsById[doc.id] = doc.data();
        }
      }

      return announcementsById.values
          .map((doc) => AnnouncementDataModel.fromMap(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }
}
