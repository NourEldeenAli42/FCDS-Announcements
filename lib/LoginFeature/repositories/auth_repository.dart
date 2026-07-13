import 'package:fcds_announcements/RecentMessagesFeature/repositories/notification_reciever_repository.dart';
import 'package:fcds_announcements/RemindersFeature/repository/reminders_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class AuthRepository {
  Future<void> nativeGoogleSignIn() async {
    final supabase = Supabase.instance.client;

    const webClientId =
        '921251262968-gmii2qoj9pdmsqcfaic7corl3pbru257.apps.googleusercontent.com';

    final scopes = ['email', 'profile'];
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(serverClientId: webClientId);
    final googleUser = await googleSignIn.attemptLightweightAuthentication();

    if (googleUser == null) {
      return;
    }

    /// Authorization is required to obtain the access token with the appropriate scopes for Supabase authentication,
    /// while also granting permission to access user information.
    final authorization =
        await googleUser.authorizationClient.authorizationForScopes(scopes) ??
        await googleUser.authorizationClient.authorizeScopes(scopes);
    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw AuthException('No ID Token found.');
    }
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
    );

    // List<String> followedPageIds = await UserRepository().getFollowedPageIds();
    // for (var pageId in followedPageIds) {
    //   FirebaseMessaging.instance.subscribeToTopic(pageId);
    // }
  }

  Future<void> signOut() async {
    await NotificationRepository().deleteAllMessages();
    RemindersRepository().flutterLocalNotificationsPlugin
        .cancelAllPendingNotifications();
    // List<String> followedPageIds = await UserRepository.getFollowedPageIds();
    // for (var pageId in followedPageIds) {
    //   FirebaseMessaging.instance.unsubscribeFromTopic(pageId);
    // }
    await Supabase.instance.client.auth.signOut();
  }
}
