import 'package:auth0_flutter/auth0_flutter.dart';
import 'supabase_service.dart';
import 'storage_service.dart';
import '../models/recipe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Auth0Service {
  final Auth0 auth0 = Auth0(
    dotenv.env['AUTH0_DOMAIN'] ?? '',
    dotenv.env['AUTH0_CLIENT_ID'] ?? '',
  );

  final SupabaseService _supabaseService = SupabaseService();
  final StorageService _storageService = StorageService();
  List<Recipe> _recipes = [];

  Future<Credentials?> login() async {
    try {
      final credentials = await auth0.webAuthentication().login(
        parameters: {
          'audience': 'https://${dotenv.env['AUTH0_DOMAIN']}/api/v2/',
        },
      );

      // Create a new JWT for Supabase using Auth0's user info
      final auth0JWT = JWT.decode(credentials.accessToken);
      final responseObject = auth0JWT.payload as Map<String, dynamic>;
      final userId = responseObject['sub'].replaceAll('|', '-'); // Convert "

      final payload = {
        'userId': userId, // This is the Auth0 user ID (sub claim)
        'exp': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/
            1000,
        "role": "authenticated"
      };

      // // Sign the JWT with Supabase's JWT secret
      final jwt = JWT(payload);
      final supabaseToken = jwt.sign(
        SecretKey(dotenv.env['SUPABASE_JWT_SECRET'] ?? ''),
        algorithm: JWTAlgorithm.HS256,
      );
      // // Initialize Supabase with the new token
      await _supabaseService.initialize(accessToken: supabaseToken);
      final supabase = Supabase.instance.client;
      // await supabase.auth.setSession(supabaseToken);

      final response = await supabase
          .from('recipes')
          .select()
          .eq('author_id', '5c6d2991-ca5f-489c-b229-516ef4efce34');
      print('Response: $response');

      _recipes = (response as List<dynamic>)
          .map((recipeData) => Recipe(
                recipe_id: recipeData['recipe_id'],
                title: recipeData['title'],
                to_pick: recipeData['to_pick'] ?? false,
              ))
          .toList();
      print('Recipes: $_recipes');

      // Print each recipe individually
      for (var recipe in _recipes) {
        print(
            'Recipe: ${recipe.recipe_id} - ${recipe.title} (To Pick: ${recipe.to_pick})');
      }

      // Optionally store the token
      // await _storageService.saveAccessToken(credentials.accessToken);

      return credentials;
    } catch (e) {
      print('Auth0 login error: $e');

      return null;
    }
  }

  Future<void> logout() async {
    try {
      await auth0.webAuthentication().logout();
      // await _supabaseService.signOut();
    } catch (e) {
      print('Auth0 logout error: $e');
    }
  }
}
