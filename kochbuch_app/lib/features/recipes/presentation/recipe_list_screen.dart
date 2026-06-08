import 'package:flutter/material.dart';
import '../data/recipe_mock_data.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezepte'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: mockRecipes.length,
        itemBuilder: (context, index) {
          final recipe = mockRecipes[index];
          return ListTile(
            leading: const Icon(Icons.restaurant_menu, color: Colors.orange),
            title: Text(recipe.title),
            subtitle: Text('${recipe.category} • ${recipe.durationMinutes} Min.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipe: recipe),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
