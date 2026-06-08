import 'package:flutter/material.dart';
import '../domain/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
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
          ],
        ),
      ),
    );
  }
}
