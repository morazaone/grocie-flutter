import 'package:flutter/material.dart';
import 'colors.dart';
import 'models/recipe.dart';
import 'providers/recipe_provider.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    super.initState();
    // Fetch recipes when widget initializes
    Future.microtask(() =>
        Provider.of<RecipeProvider>(context, listen: false).fetchUserRecipes());
  }

  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<RecipeProvider>(context).recipes;
// user id: 9b943d73-25a1-43bc-8c3e-59f5635ff865
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
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
                  key: Key(recipe.id),
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
                  onDismissed: (_) =>
                      Provider.of<RecipeProvider>(context, listen: false)
                          .deleteRecipe(recipe),
                  child: RecipeCard(
                    recipe: recipe,
                    onAddToCart: () =>
                        Provider.of<RecipeProvider>(context, listen: false)
                            .addToCart(recipe),
                    onRemoveFromCart: () =>
                        Provider.of<RecipeProvider>(context, listen: false)
                            .removeFromCart(recipe),
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
  final VoidCallback onAddToCart;
  final VoidCallback onRemoveFromCart;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.onAddToCart,
    required this.onRemoveFromCart,
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
            recipe.toPick
                ? Icons.remove_shopping_cart
                : Icons.add_shopping_cart,
            color: buttonIconColor,
          ),
          onPressed: () {
            if (recipe.toPick) {
              onRemoveFromCart();
            } else {
              onAddToCart();
            }
          },
        ),
      ),
    );
  }
}
