import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  Future<void> updateProfile(String name) async {
    await Supabase.instance.client.auth.updateUser(
      UserAttributes(data: {'full_name': name}),
    );
  }
}
