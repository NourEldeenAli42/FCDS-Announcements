import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcds_announcements/RemindersFeature/repository/reminders_repository.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  Future<User?> signInWithGoogle() async {
    final signIn = GoogleSignIn.instance;
    await signIn.initialize(
      serverClientId:
          '921251262968-of783c602bmg7go184s7mpv0dmlnhinl.apps.googleusercontent.com',
    );
    final user = await signIn.attemptLightweightAuthentication();
    await FirebaseAuth.instance.signInWithCredential(
      GoogleAuthProvider.credential(idToken: (user?.authentication)?.idToken),
    );
    final db = FirebaseFirestore.instance;
    db.collection('users').doc(_firebaseAuth.currentUser!.uid).update({
      'email': _firebaseAuth.currentUser!.email,
      'name': _firebaseAuth.currentUser!.displayName,
      'following': FieldValue.arrayUnion([]),
    });
    // Subscribe to topics for push notifications
    List<String> followedPageIds = await UserRepository().getFollowedPageIds();
    for (var pageId in followedPageIds) {
      FirebaseMessaging.instance.subscribeToTopic(pageId);
    }
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    RemindersRepository().flutterLocalNotificationsPlugin
        .cancelAllPendingNotifications();
    List<String> followedPageIds = await UserRepository().getFollowedPageIds();
    for (var pageId in followedPageIds) {
      FirebaseMessaging.instance.unsubscribeFromTopic(pageId);
    }
    await FirebaseAuth.instance.signOut();
    await _firebaseAuth.signOut();
    await GoogleSignIn.instance.signOut();
  }
}
