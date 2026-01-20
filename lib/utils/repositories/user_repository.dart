import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  // Streams the list of page IDs the user follows
  Future<List<String>> getFollowedPageIds() async {
    List<String> followedPageIds = [];
    final doc = await _db
        .collection('users')
        .doc('zjYapRWMOPQcwE61Hymcrnnsy2C2')
        .collection('following')
        .get();
    for (var document in doc.docs) {
      followedPageIds.add(document.id);
    }
    return followedPageIds;
  }
}
