import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/recipe.dart';

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  Future<void> fetchUserRecipes() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('test').select().eq('id', '1');

    // _recipes = (response as List<dynamic>)
    //     .map((recipeData) => Recipe(
    //           id: recipeData['recipe_id'],
    //           title: recipeData['title'],
    //           toPick: recipeData['toPick'] ?? false,
    //         ))
    //     .toList();

    print(response);
    notifyListeners();
  }

  void deleteRecipe(Recipe recipe) {
    _recipes.removeWhere((r) => r.id == recipe.id);
    notifyListeners();
  }

  void addToCart(Recipe recipe) {
    // Update recipe's toPick status
    final index = _recipes.indexWhere((r) => r.id == recipe.id);
    if (index != -1) {
      _recipes[index] = Recipe(
        id: recipe.id,
        title: recipe.title,
        toPick: true,
      );
      notifyListeners();
    }
  }

  void removeFromCart(Recipe recipe) {
    // Similar to addToCart but sets toPick to false
    final index = _recipes.indexWhere((r) => r.id == recipe.id);
    if (index != -1) {
      _recipes[index] = Recipe(
        id: recipe.id,
        title: recipe.title,
        toPick: false,
      );
      notifyListeners();
    }
  }
}