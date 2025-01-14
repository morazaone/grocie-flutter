import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/recipe.dart';

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  Future<void> fetchUserRecipes() async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('recipes')
        .select()
        .eq('author_id', '582e25d5-e022-4729-8052-39d598291f00');

    _recipes = (response as List<dynamic>)
        .map((recipeData) => Recipe(
              recipe_id: recipeData['recipe_id'],
              title: recipeData['title'],
              to_pick: recipeData['to_pick'] ?? false,
            ))
        .toList();

    // Print each recipe individually
    for (var recipe in _recipes) {
      print(
          'Recipe: ${recipe.recipe_id} - ${recipe.title} (To Pick: ${recipe.to_pick})');
    }
    notifyListeners();
  }

  Future<void> deleteRecipe(Recipe recipe) async {
    final supabase = Supabase.instance.client;
    await supabase.from('recipes').delete().eq('recipe_id', recipe.recipe_id);

    _recipes.removeWhere((r) => r.recipe_id == recipe.recipe_id);
    notifyListeners();
  }

  Future<void> updateCartStatus(Recipe recipe, bool toPick) async {
    final supabase = Supabase.instance.client;

    // Update in Supabase
    await supabase
        .from('recipes')
        .update({'to_pick': toPick}).eq('recipe_id', recipe.recipe_id);

    // Update local state
    final index = _recipes.indexWhere((r) => r.recipe_id == recipe.recipe_id);
    if (index != -1) {
      _recipes[index] = Recipe(
        recipe_id: recipe.recipe_id,
        title: recipe.title,
        to_pick: toPick,
      );
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _recipes = [];
    notifyListeners();
  }

  Future<void> createRecipe({
    required String title,
    required double budget,
    required String categories,
    required List<Map<String, String>> ingredients,
    required List<Map<String, String>> steps,
    required bool isPublic,
  }) async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('recipes')
        .insert({
          'title': title,
          'budget': budget,
          'categories': categories,
          'ingredients':
              ingredients, // Will be automatically converted to JSONB
          'steps': steps, // Will be automatically converted to JSONB
          'is_public': isPublic,
          'author_id': '582e25d5-e022-4729-8052-39d598291f00',
        })
        .select()
        .single();

    _recipes.add(Recipe(
      recipe_id: response['recipe_id'],
      title: title,
      // Update your Recipe model to include these new fields
    ));
    notifyListeners();
  }
}
