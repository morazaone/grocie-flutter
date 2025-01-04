class Recipe {
  final String id;
  final String title;
  final bool toPick;

  Recipe({
    required this.id,
    required this.title,
    this.toPick = false,
  });
}
