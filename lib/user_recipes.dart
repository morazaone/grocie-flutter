import 'package:flutter/material.dart';
import 'colors.dart';
import 'models/recipe.dart';
import 'providers/recipe_provider.dart';
import 'package:provider/provider.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
// import 'services/supabase_service.dart';
import 'services/auth0_service.dart';
import 'create_recipe_screen.dart';

/*
requirement: 
- user auth

Objects:
- recipes: List Recipe

methods:
- get user recipes
- add/remove cart
*/

class UserRecipes extends StatefulWidget {
  const UserRecipes({super.key});

  @override
  State<UserRecipes> createState() => _UserRecipesState();
}

class _UserRecipesState extends State<UserRecipes> {
  final Auth0Service _auth0Service = Auth0Service();
  bool _isLoggedIn = false;

  Future<void> _login() async {
    final credentials = await _auth0Service.login();
    if (credentials != null) {
      setState(() {
        _isLoggedIn = true;
      });
      // Fetch recipes after successful login
      await Provider.of<RecipeProvider>(context, listen: false)
          .fetchUserRecipes();
    }
  }

  Future<void> _logout() async {
    await _auth0Service.logout();
    setState(() {
      _isLoggedIn = false;
    });
    // set recipes to empty []
    await Provider.of<RecipeProvider>(context, listen: false).logout();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<RecipeProvider>(context).recipes;
// user id: 9b943d73-25a1-43bc-8c3e-59f5635ff865
    return Container(
      color: backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: _isLoggedIn
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateRecipeScreen()),
                  );
                },
                backgroundColor: primaryColor,
                child: const Icon(Icons.add, color: backgroundColor),
              )
            : null,
        body: Column(
          children: [
            // Add login button at the top
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _isLoggedIn ? _logout : _login,
                child: Text(_isLoggedIn ? 'Logout' : 'Login with Auth0'),
              ),
            ),
            // Title section - only show when logged in
            if (_isLoggedIn)
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'My Recipes',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            // Recipe list
            Expanded(
              child: ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return Dismissible(
                    key: Key(recipe.recipe_id),
                    background: Container(
                      color: destructiveColor,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(
                        Icons.delete,
                        color: textColor,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) async => await Provider.of<RecipeProvider>(
                            context,
                            listen: false)
                        .deleteRecipe(recipe),
                    child: RecipeCard(
                      recipe: recipe,
                      onCartStatusChanged: (bool toPick) async =>
                          await Provider.of<RecipeProvider>(context,
                                  listen: false)
                              .updateCartStatus(recipe, toPick),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final Function(bool) onCartStatusChanged;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onCartStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: searchBarBackground,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          recipe.title,
          style: const TextStyle(
            color: textColor,
            fontSize: 18,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            recipe.to_pick
                ? Icons.remove_shopping_cart
                : Icons.add_shopping_cart,
            color: buttonIconColor,
          ),
          onPressed: () {
            onCartStatusChanged(!recipe.to_pick);
          },
        ),
      ),
    );
  }
}
