import 'dart:async';
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
    FirebaseAuth.instance.signInWithCredential(
      GoogleAuthProvider.credential(idToken: (user?.authentication)?.idToken),
    );
    return _firebaseAuth.currentUser;
  }
}
