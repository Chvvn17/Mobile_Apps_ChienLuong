import 'package:flutter/material.dart';
import '../domain/recipe.dart';
import 'edit_recipe_screen.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  final int index;

  const RecipeDetailScreen({super.key, required this.recipe, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedRecipe = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRecipeScreen(recipe: recipe),
                ),
              );
              if (updatedRecipe is Recipe) {
                Navigator.pop(context, updatedRecipe);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context, 'delete');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.category, color: Colors.orange),
                const SizedBox(width: 8),
                Text(recipe.category),
                const SizedBox(width: 16),
                const Icon(Icons.timer, color: Colors.orange),
                const SizedBox(width: 8),
                Text('${recipe.durationMinutes} Minuten'),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Beschreibung',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(recipe.description),
            if (recipe.ingredients.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Zutaten',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...recipe.ingredients.map((ingredient) {
                final amount = ingredient.amount % 1 == 0
                    ? ingredient.amount.toInt().toString()
                    : ingredient.amount.toString();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(color: Colors.orange, fontSize: 18),
                      ),
                      Text('$amount ${ingredient.unit}  ${ingredient.name}'),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
