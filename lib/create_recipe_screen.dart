import 'package:flutter/material.dart';
import 'colors.dart';
import 'providers/recipe_provider.dart';
import 'package:provider/provider.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _budgetController = TextEditingController();
  final _categoriesController = TextEditingController();
  bool _isPublic = false;

  // Using List of Maps for steps and ingredients that will be converted to JSONB
  final List<Map<String, TextEditingController>> _ingredients = [];
  final List<Map<String, TextEditingController>> _steps = [];

  @override
  void dispose() {
    _titleController.dispose();
    _budgetController.dispose();
    _categoriesController.dispose();
    // Clean up ingredient controllers
    for (var ingredient in _ingredients) {
      ingredient.values.forEach((controller) => controller.dispose());
    }
    // Clean up step controllers
    for (var step in _steps) {
      step.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

  void _addIngredient() {
    setState(() {
      _ingredients.add({
        'name': TextEditingController(),
        'quantity': TextEditingController(),
        'unit': TextEditingController(),
        'department': TextEditingController(),
      });
    });
  }

  void _addStep() {
    setState(() {
      _steps.add({
        'name': TextEditingController(),
        'description': TextEditingController(),
      });
    });
  }

  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      final recipeProvider =
          Provider.of<RecipeProvider>(context, listen: false);

      // Format ingredients and steps for JSONB
      final List<Map<String, String>> ingredients = _ingredients
          .map((ingredient) => {
                'name': ingredient['name']!.text,
                'quantity': ingredient['quantity']!.text,
                'unit': ingredient['unit']!.text,
                'department': ingredient['department']!.text,
              })
          .toList();

      final List<Map<String, String>> steps = _steps
          .map((step) => {
                'name': step['name']!.text,
                'description': step['description']!.text,
              })
          .toList();

      await recipeProvider.createRecipe(
        title: _titleController.text,
        budget: double.tryParse(_budgetController.text) ?? 0.0,
        categories: _categoriesController.text,
        ingredients: ingredients,
        steps: steps,
        isPublic: _isPublic,
      );

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title field
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: textColor),
                  decoration: const InputDecoration(
                    labelText: 'Recipe Title',
                    labelStyle: TextStyle(color: textColor),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 16),

                // Ingredients Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Ingredients',
                        style: TextStyle(color: textColor, fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.add, color: primaryColor),
                      onPressed: _addIngredient,
                    ),
                  ],
                ),
                ..._ingredients.asMap().entries.map((entry) {
                  final index = entry.key;
                  final ingredient = entry.value;
                  return Card(
                    color: searchBarBackground,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: ingredient['name'],
                                  style: const TextStyle(color: textColor),
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    labelStyle: TextStyle(color: textColor),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _ingredients.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: ingredient['quantity'],
                                  style: const TextStyle(color: textColor),
                                  decoration: const InputDecoration(
                                    labelText: 'Quantity',
                                    labelStyle: TextStyle(color: textColor),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: ingredient['unit'],
                                  style: const TextStyle(color: textColor),
                                  decoration: const InputDecoration(
                                    labelText: 'Unit',
                                    labelStyle: TextStyle(color: textColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: ingredient['department'],
                            style: const TextStyle(color: textColor),
                            decoration: const InputDecoration(
                              labelText: 'Department',
                              labelStyle: TextStyle(color: textColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                // Steps Section
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Steps',
                        style: TextStyle(color: textColor, fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.add, color: primaryColor),
                      onPressed: _addStep,
                    ),
                  ],
                ),
                ..._steps.asMap().entries.map((entry) {
                  final index = entry.key;
                  final step = entry.value;
                  return Card(
                    color: searchBarBackground,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: step['name'],
                                  style: const TextStyle(color: textColor),
                                  decoration: InputDecoration(
                                    labelText: 'Step ${index + 1} Name',
                                    labelStyle:
                                        const TextStyle(color: textColor),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _steps.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: step['description'],
                            style: const TextStyle(color: textColor),
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              labelStyle: TextStyle(color: textColor),
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                // Other Fields
                const SizedBox(height: 16),
                TextFormField(
                  controller: _budgetController,
                  style: const TextStyle(color: textColor),
                  decoration: const InputDecoration(
                    labelText: 'Budget',
                    labelStyle: TextStyle(color: textColor),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _categoriesController,
                  style: const TextStyle(color: textColor),
                  decoration: const InputDecoration(
                    labelText: 'Categories',
                    labelStyle: TextStyle(color: textColor),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Public Recipe',
                      style: TextStyle(color: textColor)),
                  value: _isPublic,
                  onChanged: (bool value) {
                    setState(() {
                      _isPublic = value;
                    });
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
      ),
    );
  }
}
