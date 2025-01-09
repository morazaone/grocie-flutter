import 'package:supabase_flutter/supabase_flutter.dart'
    show Supabase, AuthFlowType;
import 'package:supabase/supabase.dart' show AuthOptions;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'storage_service.dart';
import 'package:auth0_flutter/auth0_flutter.dart';

class SupabaseService {
  final StorageService _storageService = StorageService();
  late final Auth0 auth0;

  SupabaseService() {
    auth0 = Auth0(
      dotenv.env['AUTH0_CLIENT_ID']!,
      dotenv.env['AUTH0_DOMAIN']!,
    );
  }

  Future<void> initialize({String? accessToken}) async {
    try {
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
        headers: {
          'Authorization': 'Bearer ${accessToken}',
        },
      );
    } catch (e) {
      print('Error initializing Supabase: $e');
    }
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    await _storageService.deleteTokens();
  }

  Future<void> updateAuthToken(String accessToken) async {
    await Supabase.instance.dispose();
    await initialize(accessToken: accessToken);
  }
}
