import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../domain/recipe.dart';
import 'edit_recipe_screen.dart';

/// Zeigt die vollständige Detailansicht eines einzelnen Rezeptes.
class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  /// Baut den Detail-Screen mit Meta-Karte, Beschreibung, Zutaten sowie Bearbeiten- und Löschen-Aktion.
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(recipe.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final updatedRecipe = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditRecipeScreen(recipe: recipe),
                    ),
                  );
                  if (updatedRecipe is Recipe) {
                    navigator.pop(updatedRecipe);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('recipes')
                      .doc(recipe.id)
                      .delete();
                  if (context.mounted) Navigator.pop(context, 'delete');
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.category_outlined,
                            color: colorScheme.onPrimaryContainer, size: 18),
                        const SizedBox(width: 6),
                        Text(recipe.category,
                            style: TextStyle(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w500)),
                        const Spacer(),
                        Icon(Icons.timer_outlined,
                            color: colorScheme.onPrimaryContainer, size: 18),
                        const SizedBox(width: 6),
                        Text('${recipe.durationMinutes} Minuten',
                            style: TextStyle(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Beschreibung',
                      style: textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(recipe.description, style: textTheme.bodyMedium),
                  if (recipe.ingredients.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Zutaten',
                        style: textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: recipe.ingredients.map((ingredient) {
                            final amount = ingredient.amount % 1 == 0
                                ? ingredient.amount.toInt().toString()
                                : ingredient.amount.toString();
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '$amount ${ingredient.unit}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(ingredient.name,
                                      style: textTheme.bodyMedium),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
