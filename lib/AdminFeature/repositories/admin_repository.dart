import 'package:fcds_announcements/AdminFeature/Data%20Models/instructor_data_model.dart';
import 'package:fcds_announcements/AdminFeature/Data%20Models/user_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
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

  static Future<List<UserDataModel>> getAllUsers() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('profiles').select();

    final List<UserDataModel> usersData = response
        .map((map) => UserDataModel.fromMap(map))
        .toList();
    return usersData;
  }

  static Future<void> removeAdminPermission(UserDataModel user) async {
    final supabase = Supabase.instance.client;

    await supabase.from('profiles').update({'admin': false}).eq('id', user.id);
  }

  static Future<void> addAdminPermission(UserDataModel user) async {
    final supabase = Supabase.instance.client;
    await supabase.from('profiles').update({'admin': true}).eq('id', user.id);
  }

  static Future<List<PageDataModel>> getPagesWithPermissions(
    String userId,
  ) async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('permissions')
        .select('''
        page_id,
        pages (
          *,
          courses ( course_name ),
          instructors ( instructor_name )
        )
      ''')
        .eq('user_id', userId);

    final List<PageDataModel> pagesData = [];
    for (var item in response) {
      final pageMap = item['pages'] as Map<String, dynamic>;
      pageMap['type'] =
          '${pageMap['courses']['course_name']} ${pageMap['type']}';
      final pageData = PageDataModel.fromMap(pageMap);
      pagesData.add(pageData);
    }

    return pagesData;
  }

  static Future<void> removePermissions(String userId, int pageId) async {
    final supabase = Supabase.instance.client;

    await supabase
        .from('permissions')
        .delete()
        .eq('user_id', userId)
        .eq('page_id', pageId);
  }

  static Future<List<PageDataModel>> getPagesWithoutPermissions(
    String userId,
  ) async {
    final supabase = Supabase.instance.client;

    // 1) Get all page_ids that the user HAS permissions for
    final perms = await supabase
        .from('permissions')
        .select('page_id')
        .eq('user_id', userId);

    final List<int> allowedPageIds = (perms as List)
        .map((e) => e['page_id'] as int)
        .toList();

    // 2) Get pages that are NOT in that list
    final response = await supabase.from('pages').select('''
        *,
        courses ( course_name ),
        instructors ( instructor_name )
      ''');

    // If you have a lot of pages, we can do the filtering in SQL (RPC),
    // but for small datasets this in-memory filter is simplest.
    final pagesData = <PageDataModel>[];
    for (var item in response) {
      final pageId = item['id'] as int;

      if (!allowedPageIds.contains(pageId)) {
        // Add/derive fields like you did before
        item['type'] =
            '${item['courses']?['course_name'] ?? ''} ${item['type']}';

        final pageData = PageDataModel.fromMap(item);
        pagesData.add(pageData);
      }
    }

    return pagesData;
  }

  static Future<void> addPermissions(String userId, int pageId) async {
    final supabase = Supabase.instance.client;

    await supabase.from('permissions').insert({
      'user_id': userId,
      'page_id': pageId,
    });
  }

  static Future<List<CourseDataModel>> fetchCourses() async {
    final supabase = Supabase.instance.client;

    final response = await supabase.from('courses').select();

    final List<CourseDataModel> coursesData = response
        .map((map) => CourseDataModel.fromDocument(map))
        .toList();
    return coursesData;
  }

  static Future<void> updateCourse(CourseDataModel course) async {
    final supabase = Supabase.instance.client;

    await supabase
        .from('courses')
        .update({
          'course_name': course.name,
          'description': course.description,
          'credits': course.credits,
        })
        .eq('id', course.id);
  }

  static Future<void> deleteCourse(int courseId) async {
    final supabase = Supabase.instance.client;

    await supabase.from('courses').delete().eq('id', courseId);
  }

  static Future<void> addCourse(CourseDataModel course) async {
    final supabase = Supabase.instance.client;

    await supabase.from('courses').insert({
      'course_name': course.name,
      'description': course.description,
      'credits': course.credits,
    });
  }

  static Future<List<Map<CourseDataModel, List<PageDataModel>>>>
  loadPages() async {
    final supabase = Supabase.instance.client;

    // Fetch all courses
    final coursesResponse = await supabase.from('courses').select();
    final List<CourseDataModel> courses = coursesResponse
        .map((map) => CourseDataModel.fromDocument(map))
        .toList();
    final pagesResponse = await supabase
        .from('pages')
        .select('*, instructors (instructor_name)');
    final pages = pagesResponse
        .map((map) => PageDataModel.fromMap(map))
        .toList();
    List<Map<CourseDataModel, List<PageDataModel>>> result = [];
    for (var course in courses) {
      final coursePages = pages
          .where((page) => page.courseId == course.id)
          .toList();
      result.add({course: coursePages});
    }

    return result;
  }

  static Future<void> deletePage(int pageId) async {
    final supabase = Supabase.instance.client;

    await supabase.from('pages').delete().eq('id', pageId);
  }

  static Future<List<InstructorDataModel>> fetchInstructors() async {
    final supabase = Supabase.instance.client;

    final response = await supabase.from('instructors').select();

    final List<InstructorDataModel> instructorsData = response
        .map((map) => InstructorDataModel.fromJson(map))
        .toList();
    return instructorsData;
  }

  //TODO: Under Construction: Implement the editPage method to update page details in the database.
  static Future<void> editPage(PageDataModel page) async {
    final supabase = Supabase.instance.client;

    await supabase.from('pages').update({});
  }

  static Future<void> addPriorityDeadline({
    required String title,
    required DateTime deadline,
    required int pageId,
  }) async {
    final supabase = Supabase.instance.client;

    await supabase.from('announcements').insert({
      'title': title,
      'page_id': pageId,
      'deadline': deadline.toIso8601String(),
      'publisher':
          supabase.auth.currentUser?.id, // Assuming the user is logged in
    });
  }
}
