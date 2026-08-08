import 'package:flutter/material.dart';
import '../data/recipe_mock_data.dart';
import '../domain/recipe.dart';
import 'recipe_detail_screen.dart';
import 'add_recipe_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<Recipe> _recipes = List.from(mockRecipes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezepte'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          final recipe = _recipes[index];
          return ListTile(
            leading: const Icon(Icons.restaurant_menu, color: Colors.orange),
            title: Text(recipe.title),
            subtitle: Text('${recipe.category} • ${recipe.durationMinutes} Min.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RecipeDetailScreen(recipe: recipe, index: index),
                ),
              );
              if (result is Recipe) {
                setState(() {
                  _recipes[index] = result;
                });
              } else if (result == 'delete') {
                setState(() {
                  _recipes.removeAt(index);
                });
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          final newRecipe = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRecipeScreen(),
            ),
          );
          if (newRecipe is Recipe) {
            setState(() {
              _recipes.add(newRecipe);
            });
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
