import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: 'https://fwxumnvhdgawppewahlm.supabase.co',
    publishableKey: 'sb_publishable_lChog43lBhyds6ZUZPcpnw_oKPQIIeM',
  );
  }