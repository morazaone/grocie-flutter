class Recipe {
  final String recipe_id;
  final String title;
  final bool to_pick;

  Recipe({
    required this.recipe_id,
    required this.title,
    this.to_pick = false,
  });
}
