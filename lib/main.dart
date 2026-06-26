import 'package:fcds_announcements/LoginFeature/login_view.dart';
import 'package:fcds_announcements/HomeFeature/home_view.dart';
import 'package:fcds_announcements/PageFeedFeature/page_feed_view.dart';
import 'package:fcds_announcements/ProfileFeature/profile_view.dart';
import 'package:fcds_announcements/RecentMessagesFeature/messages_view.dart';
import 'package:fcds_announcements/RemindersFeature/bloc/Events%20Bloc/events_bloc.dart';
import 'package:fcds_announcements/main_view.dart';
import 'package:fcds_announcements/RemindersFeature/bloc/Reminders%20Bloc/reminders_bloc.dart';
import 'package:fcds_announcements/utils/AI%20Model/core_model.dart';
import 'package:fcds_announcements/utils/supabase.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:fcds_announcements/utils/repositories/firebase_messaging_repository.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    providerAndroid: AndroidDebugProvider(),
    providerWeb: ReCaptchaV3Provider(
      '6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI',
    ),
  );
  await FirebaseMessagingRepository().initNotifications();
  if (!kIsWeb) {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  analytics.logAppOpen();
  AIModel.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        '/home': (context) => HomeView(),
        '/messages': (context) => MessagesView(),
        '/profile': (context) => ProfileView(),
        '/feed': (context) => PageFeedView(),
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
    return StreamBuilder<AuthState?>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session;

        if (session == null) {
          return const LoginView();
        }

        return BlocProvider(
          create: (context) => RemindersBloc(),
          child: BlocProvider(
            create: (context) => EventsBloc(),
            child: MainView(),
          ),
        );
      },
    );
  }
}
