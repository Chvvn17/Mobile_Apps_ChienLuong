import 'ingredient.dart';

/// Datenmodell für ein Rezept in der Kochbuch-App.
class Recipe {
  final String id;
  final String title;
  final String description;
  final String category;
  final int durationMinutes;
  final List<Ingredient> ingredients;

  /// Erstellt ein Rezept; [ingredients] ist standardmässig eine leere Liste.
  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.durationMinutes,
    this.ingredients = const [],
  });
}
