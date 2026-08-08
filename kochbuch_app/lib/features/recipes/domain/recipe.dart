import 'ingredient.dart';

class Recipe {
  final String title;
  final String description;
  final String category;
  final int durationMinutes;
  final List<Ingredient> ingredients;

  const Recipe({
    required this.title,
    required this.description,
    required this.category,
    required this.durationMinutes,
    this.ingredients = const [],
  });
}
