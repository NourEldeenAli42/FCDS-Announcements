import 'dart:developer';

import 'package:fcds_announcements/RecentMessagesFeature/repositories/notification_reciever_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:url_launcher/url_launcher.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationRepository.saveNotification(message);
}

@pragma('vm:entry-point')
void _onDidReceiveBackgroundNotificationResponse(
  NotificationResponse notificationResponse,
) {
  final payload = notificationResponse.payload;
  if (payload == null || payload.isEmpty) {
    return;
  }

  final uri = Uri.tryParse(payload);
  if (uri != null) {
    launchUrl(uri);
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FirebaseMessagingRepository {
  AndroidNotificationChannel highPriorityChannel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high, // This is the key for the "heads-up" pop-up
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> _handleTapUrl(String? url) async {
    if (url == null || url.isEmpty) {
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri);
    }
  }

  Future<void> _handleMessageTap(RemoteMessage message) async {
    await NotificationRepository.saveNotification(message);
    await _handleTapUrl(message.data['url']);
  }

  Future<void> _onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    await _handleTapUrl(notificationResponse.payload);
    log('Notification tapped with payload: ${notificationResponse.payload}');
  }

  Future<void> initNotifications() async {
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
    const initSettingsAndroid = AndroidInitializationSettings('logo');
    const initSettings = InitializationSettings(android: initSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveBackgroundNotificationResponse,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()!
        .requestExactAlarmsPermission();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(highPriorityChannel);
    await _firebaseMessaging.requestPermission(provisional: true);
    FirebaseMessaging.onMessage.listen(handleNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      await _handleMessageTap(initialMessage);
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

Future<void> handleNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  String? url = message.data['url'];

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      payload: url,
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          channelDescription:
              'This channel is used for important notifications.', // description
          icon: 'logo', // Ensure you have added the icon in drawable folders
          importance:
              Importance.high, // This is the key for the "heads-up" pop-up
          priority: Priority.high,

          // other properties...
        ),
      ),
    );
  }
  await NotificationRepository.saveNotification(message);
}
