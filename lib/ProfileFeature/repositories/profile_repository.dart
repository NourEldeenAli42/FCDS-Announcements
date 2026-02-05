import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepository {
  final db = FirebaseFirestore.instance;
  Future<void> updateProfile(String name) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    await db.collection('users').doc(userId).update({'name': name});
  }
}
