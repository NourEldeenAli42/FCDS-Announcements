import 'package:fcds_announcements/PageFeedFeature/Data%20Models/announcement_data_model.dart';
import 'package:fcds_announcements/PageFeedFeature/Data%20Models/page_feed_data_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedRepository {
  static Future<List<AnnouncementDataModel>> fetchAnnouncements(
    int pageId,
  ) async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('announcements')
        .select()
        .eq('page_id', pageId)
        .order('created_at', ascending: false);
    List<AnnouncementDataModel> announcements = [];
    for (var post in response) {
      announcements.add(AnnouncementDataModel.fromMap(post));
    }
    return announcements;
  }

  static Future<PageFeedDataModel> fetchPage(int pageId) async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('pages')
        .select('*, courses(id, course_name)')
        .eq('id', pageId)
        .single();
    return PageFeedDataModel.fromMap(response);
  }

  static Future<bool> flipNotificationStatus({required int pageId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool currentStatus = prefs.getBool(pageId.toString()) ?? false;
    if (currentStatus) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(pageId.toString());
      await prefs.setBool(pageId.toString(), false);
      return false;
    } else {
      await FirebaseMessaging.instance.subscribeToTopic(pageId.toString());
      await prefs.setBool(pageId.toString(), true);
      return true;
    }
  }

  static Future<bool> isNotificationEnabled(int pageId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(pageId.toString()) ?? false;
  }
}
