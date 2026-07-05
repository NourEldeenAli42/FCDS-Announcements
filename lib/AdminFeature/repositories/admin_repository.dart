import 'package:fcds_announcements/PageFeedFeature/Data%20Models/announcement_data_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminRepository {
  static Future<bool> addUrgentAnnouncement({
    required String chipText,
    required String title,
    required String content,
    required bool notificationEnabled,
    required int pageId,
    required String redirectLink,
  }) async {
    final supabase = Supabase.instance.client;

    await supabase.from('announcements').insert({
      'chip_text': chipText,
      'title': title,
      'content': content,
      'is_urgent': true,
      'page_id': pageId, // Replace with the actual page ID if needed
      'publisher':
          supabase.auth.currentUser?.id, // Assuming the user is logged in
      'redirect_link': redirectLink, // Add the redirect link to the database
    });

    if (notificationEnabled) {
      await sendNotification(title: title, content: content, pageId: pageId);
    }

    return true;
  }

  static Future<void> addAnnouncement({
    required String title,
    required String content,
    required int pageId,
    required String redirectLink,
  }) async {
    final supabase = Supabase.instance.client;

    await supabase.from('announcements').insert({
      'title': title,
      'content': content,
      'is_urgent': false,
      'page_id': pageId, // Replace with the actual page ID if needed
      'publisher':
          supabase.auth.currentUser?.id, // Assuming the user is logged in
      'redirect_link': redirectLink, // Add the redirect link to the database
    });
  }

  static Future<void> editAnnouncement({
    required AnnouncementDataModel announcement,
  }) async {
    final supabase = Supabase.instance.client;

    await supabase
        .from('announcements')
        .update({
          'title': announcement.title,
          'content': announcement.content,
          'redirect_link':
              announcement.redirectLink, // Update the redirect link
        })
        .eq('id', announcement.id);
  }

  static Future<void> deleteAnnouncement(int announcementId) async {
    final supabase = Supabase.instance.client;

    try {
      await supabase.from('announcements').delete().eq('id', announcementId);
    } catch (e) {
      rethrow; // Rethrow the exception to be handled by the caller
    }
  }

  static Future<void> sendNotification({
    required String title,
    required String content,
    required int pageId,
  }) async {
    final supabase = Supabase.instance.client;
    await supabase.functions.invoke(
      'push-notification',
      body: {
        'topic': pageId.toString(), // <-- Changed from 3 to '3'
        'title': title,
        'body': content,
      },
    );
  }
}
