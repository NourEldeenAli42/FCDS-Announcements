import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcds_announcements/RecentMessagesFeature/repositories/notification_reciever_repository.dart';
import 'package:fcds_announcements/RemindersFeature/repository/reminders_repository.dart';
import 'package:fcds_announcements/utils/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  Future<UserCredential?> signInWithGoogleWeb() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    // Optional: Add custom parameters
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    try {
      // Trigger the popup authentication flow
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } catch (e) {
      log("Error during Google Sign-In: $e");
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    if (kIsWeb) {
      final userCredential = await signInWithGoogleWeb();
      return userCredential?.user;
    }
    final signIn = GoogleSignIn.instance;
    await signIn.initialize(
      serverClientId: kIsWeb
          ? null
          : '921251262968-of783c602bmg7go184s7mpv0dmlnhinl.apps.googleusercontent.com',
      clientId:
          '921251262968-of783c602bmg7go184s7mpv0dmlnhinl.apps.googleusercontent.com',
    );
    final user = await signIn.attemptLightweightAuthentication();
    await FirebaseAuth.instance.signInWithCredential(
      GoogleAuthProvider.credential(idToken: (user?.authentication)?.idToken),
    );
    final db = FirebaseFirestore.instance;
    final userDoc = await db
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();
    if (!userDoc.exists) {
      await db.collection('users').doc(_firebaseAuth.currentUser!.uid).set({
        'name': _firebaseAuth.currentUser!.displayName,
        'email': _firebaseAuth.currentUser!.email,
        'following': ['welcoming'],
      });
    }

    // Subscribe to topics for push notifications
    List<String> followedPageIds = await UserRepository().getFollowedPageIds();
    for (var pageId in followedPageIds) {
      FirebaseMessaging.instance.subscribeToTopic(pageId);
    }
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await NotificationRepository().deleteAllMessages();
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
