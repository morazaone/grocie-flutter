import 'package:flutter/material.dart';
import 'user_recipes.dart';
import 'package:provider/provider.dart';
import 'providers/recipe_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  // final supabaseService = SupabaseService();
  // await supabaseService.initialize();
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
        home: const UserRecipes(),
      ),
    );
  }
}
