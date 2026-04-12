import 'dart:developer';

import 'package:fcds_announcements/LoginFeature/login_view.dart';
import 'package:fcds_announcements/HomeFeature/home_view.dart';
import 'package:fcds_announcements/ProfileFeature/profile_view.dart';
import 'package:fcds_announcements/RecentMessagesFeature/messages_view.dart';
import 'package:fcds_announcements/RemindersFeature/bloc/Events%20Bloc/events_bloc.dart';
import 'package:fcds_announcements/main_view.dart';
import 'package:fcds_announcements/RemindersFeature/bloc/Reminders%20Bloc/reminders_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    providerAndroid: AndroidDebugProvider(),
    providerWeb: ReCaptchaV3Provider(
      '6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI',
    ),
  );
  // await FirebaseMessagingRepository().initNotifications();
  if (!kIsWeb) {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }
  log("Token initialized: ${await FirebaseMessaging.instance.getToken()}");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => HomeView(),
        '/messages': (context) => MessagesView(),
        '/profile': (context) => ProfileView(),
      },
      title: 'FCDS Announcements',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder listens to the Firebase Auth state
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. Check if the connection is still loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. If the snapshot has user data, they are logged in
        if (snapshot.hasData) {
          return BlocProvider(
            create: (context) => RemindersBloc(),
            child: BlocProvider(
              create: (context) => EventsBloc(),
              child: MainView(),
            ),
          );
        }

        // 3. Otherwise, show the login screen
        return const LoginView();
      },
    );
  }
}
