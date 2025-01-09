import 'package:flutter/material.dart';
import 'colors.dart';
import 'providers/recipe_provider.dart';
import 'package:provider/provider.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({Key? key}) : super(key: key);

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      final recipeProvider =
          Provider.of<RecipeProvider>(context, listen: false);
      // Add method to save recipe in RecipeProvider
      await recipeProvider.createRecipe(_titleController.text);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Create Recipe',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: searchBarBackground,
        iconTheme: const IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: textColor),
                decoration: const InputDecoration(
                  labelText: 'Recipe Title',
                  labelStyle: TextStyle(color: textColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a recipe title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveRecipe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: backgroundColor,
                ),
                child: const Text('Save Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
