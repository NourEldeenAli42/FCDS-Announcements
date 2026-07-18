import 'package:fcds_announcements/AdminFeature/admin_view.dart';
import 'package:fcds_announcements/AdminFeature/bloc/manage_courses_bloc/manage_courses_bloc.dart';
import 'package:fcds_announcements/AdminFeature/bloc/manage_pages_bloc/manage_pages_bloc.dart';
import 'package:fcds_announcements/AdminFeature/manage_courses_view.dart';
import 'package:fcds_announcements/AdminFeature/manage_pages_view.dart';
import 'package:fcds_announcements/AdminFeature/manage_users_view.dart';
import 'package:fcds_announcements/AdminFeature/permessions_view.dart';
import 'package:fcds_announcements/ChatFeature/chat_view.dart';
import 'package:fcds_announcements/LoginFeature/login_view.dart';
import 'package:fcds_announcements/HomeFeature/home_view.dart';
import 'package:fcds_announcements/OnBoardingFeature/host_screen.dart';
import 'package:fcds_announcements/PageFeedFeature/page_feed_view.dart';
import 'package:fcds_announcements/ProfileFeature/profile_view.dart';
import 'package:fcds_announcements/RecentMessagesFeature/messages_view.dart';
import 'package:fcds_announcements/RemindersFeature/bloc/Events%20Bloc/events_bloc.dart';
import 'package:fcds_announcements/main_view.dart';
import 'package:fcds_announcements/RemindersFeature/bloc/Reminders%20Bloc/reminders_bloc.dart';
import 'package:fcds_announcements/utils/AI%20Model/core_model.dart';
import 'package:fcds_announcements/utils/app_keys.dart';
import 'package:fcds_announcements/utils/supabase.dart';
import 'package:fcds_announcements/utils/theme/app_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:fcds_announcements/utils/repositories/firebase_messaging_repository.dart';

import 'package:fcds_announcements/utils/theme/theme_cubit.dart';

late final bool firstTimeUser;

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
  final prefs = await SharedPreferences.getInstance();
  firstTimeUser = prefs.getBool('firstTimeUser') ?? true;

  // Load saved theme settings before running the app
  final themeState = await ThemeCubit.loadThemeSettings();

  runApp(MyApp(initialThemeState: themeState));
}

class MyApp extends StatelessWidget {
  final ThemeState initialThemeState;

  const MyApp({super.key, required this.initialThemeState});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(
        initialThemeType: initialThemeState.themeType,
        initialThemeMode: initialThemeState.themeMode,
      ),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            scaffoldMessengerKey: scaffoldMessengerKey,
            routes: {
              '/home': (context) => HomeView(),
              '/messages': (context) => MessagesView(),
              '/profile': (context) => ProfileView(),
              '/feed': (context) => PageFeedView(pageId: 0),
              '/admin': (context) => AdminView(),
              '/auth': (context) => AuthWrapper(),
              '/users': (context) => ManageUsersView(),
              '/permissions': (context) => PermessionsView(),
              '/manage_courses': (context) => BlocProvider<ManageCoursesBloc>(
                create: (context) => ManageCoursesBloc()..add(LoadCourses()),
                child: ManageCoursesView(),
              ),
              '/manage_subjects': (context) => BlocProvider(
                create: (context) => ManagePagesBloc()..add(LoadPagesEvent()),
                child: ManagePagesView(),
              ),
              '/ai_chat': (context) => const ChatView(),
            },
            title: 'FCDS Announcements',
            theme: AppTheme.getTheme(state.themeType, Brightness.light),
            darkTheme: AppTheme.getTheme(state.themeType, Brightness.dark),
            themeMode: state.themeMode,

            home: firstTimeUser ? const HostScreen() : const AuthWrapper(),
          );
        },
      ),
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
