import 'package:flutter/material.dart';
import 'colors.dart';
import 'models/recipe.dart';
import 'providers/recipe_provider.dart';
import 'package:provider/provider.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
// import 'services/supabase_service.dart';
import 'services/auth0_service.dart';

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
  const UserRecipes({Key? key}) : super(key: key);

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
    }
  }

  Future<void> _logout() async {
    await _auth0Service.logout();
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch recipes when widget initializes
    // Future.microtask(() =>
    //     Provider.of<RecipeProvider>(context, listen: false).fetchUserRecipes());
  }

  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<RecipeProvider>(context).recipes;
// user id: 9b943d73-25a1-43bc-8c3e-59f5635ff865
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          // Add login button at the top
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _isLoggedIn ? _logout : _login,
              child: Text(_isLoggedIn ? 'Logout' : 'Login with Auth0'),
            ),
          ),
          // Title section
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
                  onDismissed: (_) async =>
                      await Provider.of<RecipeProvider>(context, listen: false)
                          .deleteRecipe(recipe),
                  child: RecipeCard(
                    recipe: recipe,
                    onCartStatusChanged: (bool to_pick) async =>
                        await Provider.of<RecipeProvider>(context,
                                listen: false)
                            .updateCartStatus(recipe, to_pick),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final Function(bool) onCartStatusChanged;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.onCartStatusChanged,
  }) : super(key: key);

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
