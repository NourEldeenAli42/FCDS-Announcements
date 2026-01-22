import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcds_announcements/HomeFeature/Models/priority_deadline_data_model.dart';

class PriorityDeadlineRepository {
  final FirebaseFirestore _firestore;

  PriorityDeadlineRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<PriorityDeadlineDataModel?> getPriorityDeadline(
    List<String> followedPageIds,
  ) async {
    if (followedPageIds.isEmpty) return null;

    final query = await _firestore
        .collection('announcements')
        .where('page_id', whereIn: followedPageIds)
        .orderBy('deadline', descending: false)
        .orderBy('post_time', descending: true)
        .where('deadline', isGreaterThan: Timestamp.now())
        .limit(1)
        .get();
    if (query.docs.isEmpty) {
      return null;
    }
    final announcement = PriorityDeadlineDataModel.fromFirestore(
      query.docs.first.data(),
    );
    return announcement;
  }
}
