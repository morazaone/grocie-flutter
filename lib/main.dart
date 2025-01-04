import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'notes_page.dart';
import 'services/supabase_service.dart';
import 'user_recipes.dart';
import 'package:provider/provider.dart';
import 'providers/recipe_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabaseService = SupabaseService();
  await supabaseService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        // Add other providers here if needed
      ],
      child: MaterialApp(
        title: 'Grocie',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: const UserRecipes(context),
        home: const NotesPage(),
      ),
    );
  }
}
