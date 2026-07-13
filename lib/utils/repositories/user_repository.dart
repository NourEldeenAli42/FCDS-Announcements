import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  static final supuser = Supabase.instance.client.auth.currentUser;

  static Future<String?> fetchUsername() async {
    final supabase = Supabase.instance.client;

    final user = supabase.auth.currentUser;

    if (user == null) return null;
    // not signed in

    final response = await supabase
        .from('profiles')
        .select('username')
        .eq('id', user.id)
        .maybeSingle();

    return response?['username'] as String?;
  }

  static Future<void> updateProfileName({required String displayName}) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      throw Exception('User not authenticated yet');
    }

    await Supabase.instance.client
        .from('profiles')
        .update({'name': displayName})
        .eq('id', user.id)
        .select();
  }

  static Future<bool> isUserAdmin() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      throw Exception('User not authenticated yet');
    }

    final response = await Supabase.instance.client
        .from('profiles')
        .select('admin')
        .eq('id', user.id)
        .single();

    return response['admin'] ?? false;
  }

  final user = FirebaseAuth.instance.currentUser;

  // Streams the list of page IDs the user follows
  static Future<List<int>> getFollowedPageIds() async {
    List<int> followedPageIds = [];
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated yet');
    }
    final response = await supabase
        .from('follows')
        .select()
        .eq('user_id', user.id);
    for (var document in response.map((e) => e['page_id'])) {
      followedPageIds.add(document);
    }
    return followedPageIds;
  }

  static Future<bool> userHasPermission(int pageId) async {
    if (await isUserAdmin()) {
      return true;
    }
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated yet');
    }
    final response = await supabase
        .from('permissions')
        .select()
        .eq('user_id', user.id)
        .eq('page_id', pageId);
    return response.isNotEmpty;
  }
}
