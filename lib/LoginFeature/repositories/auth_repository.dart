import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    db.collection('users').doc(_firebaseAuth.currentUser!.uid).set({
      'email': _firebaseAuth.currentUser!.email,
      'name': _firebaseAuth.currentUser!.displayName,
      'following': [],
    }, SetOptions(merge: true));
    return _firebaseAuth.currentUser;
  }
}
