import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/***
 * 
 * 
 * 
 * Not using it yet
 * 
 * 
 * 
 * 
 * */
class StorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Keys for storing tokens
  static const String _accessTokenKey = 'SUPABASE_ACCESS_TOKEN';
  static const String _refreshTokenKey = 'SUPABASE_REFRESH_TOKEN';

  // Save tokens
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  // Get tokens
  Future<Map<String, String?>> getTokens() async {
    final accessToken = await _storage.read(key: _accessTokenKey);
    final refreshToken = await _storage.read(key: _refreshTokenKey);

    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  // Delete tokens
  Future<void> deleteTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
