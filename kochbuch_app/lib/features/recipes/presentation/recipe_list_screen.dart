import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../domain/ingredient.dart';
import '../domain/recipe.dart';
import 'recipe_detail_screen.dart';
import 'add_recipe_screen.dart';

/// Zeigt alle gespeicherten Rezepte als scrollbare Kartenliste.
class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  bool _isLoading = true;
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('recipes').get();
    setState(() {
      _recipes = snapshot.docs.map((doc) {
        final data = doc.data();
        final ingredientsData = (data['ingredients'] as List<dynamic>? ?? []);
        return Recipe(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          category: data['category'] ?? 'Sonstiges',
          durationMinutes: (data['durationMinutes'] as num?)?.toInt() ?? 0,
          ingredients: ingredientsData
              .map((i) => Ingredient(
                    name: i['name'] ?? '',
                    amount: (i['amount'] as num?)?.toDouble() ?? 0,
                    unit: i['unit'] ?? '',
                  ))
              .toList(),
        );
      }).toList();
      _isLoading = false;
    });
  }

  /// Baut die Rezeptliste mit [SliverAppBar] und FAB zum Hinzufügen neuer Rezepte.
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text('Meine Rezepte'),
          ),
          if (_recipes.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.restaurant_menu_outlined,
                        size: 64, color: colorScheme.outlineVariant),
                    const SizedBox(height: 16),
                    Text(
                      'Noch keine Rezepte vorhanden.',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              sliver: SliverList.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  final recipe = _recipes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.restaurant_menu,
                            color: colorScheme.onPrimaryContainer),
                      ),
                      title: Text(
                        recipe.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                            '${recipe.category} • ${recipe.durationMinutes} Min.'),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 14, color: colorScheme.onSurfaceVariant),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipeDetailScreen(recipe: recipe),
                          ),
                        );
                        if (result is Recipe) {
                          setState(() => _recipes[index] = result);
                        } else if (result == 'delete') {
                          await FirebaseFirestore.instance
                              .collection('recipes')
                              .doc(recipe.id)
                              .delete();
                          setState(() => _recipes.removeAt(index));
                        }
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newRecipe = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddRecipeScreen()),
          );
          if (newRecipe is Recipe) {
            setState(() => _recipes.add(newRecipe));
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Neues Rezept'),
      ),
    );
  }
}
