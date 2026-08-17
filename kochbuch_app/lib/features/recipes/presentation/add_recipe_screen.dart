import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../domain/recipe.dart';
import '../domain/ingredient.dart';
import 'ingredient_form.dart';

/// Formular zum Erfassen eines neuen Rezeptes mit Validierung.
class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _durationController = TextEditingController();
  final List<IngredientEntry> _ingredients = [];

  /// Gibt alle Controller und Zutaten-Einträge frei.
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _durationController.dispose();
    for (final entry in _ingredients) {
      entry.dispose();
    }
    super.dispose();
  }

  /// Validiert das Formular, speichert in Firestore und gibt das neue [Recipe] zurück.
  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      final ingredients = _ingredients
          .where((e) => e.nameController.text.trim().isNotEmpty)
          .map((e) => Ingredient(
                name: e.nameController.text.trim(),
                amount: double.tryParse(e.amountController.text.trim()) ?? 0,
                unit: e.unit,
              ))
          .toList();

      final category = _categoryController.text.trim().isEmpty
          ? 'Sonstiges'
          : _categoryController.text.trim();

      final docRef = await FirebaseFirestore.instance
          .collection('recipes')
          .add({
            'title': _titleController.text.trim(),
            'description': _descriptionController.text.trim(),
            'category': category,
            'durationMinutes':
                int.tryParse(_durationController.text.trim()) ?? 0,
            'ingredients': ingredients
                .map((i) => {
                      'name': i.name,
                      'amount': i.amount,
                      'unit': i.unit,
                    })
                .toList(),
          });

      final newRecipe = Recipe(
        id: docRef.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: category,
        durationMinutes: int.tryParse(_durationController.text.trim()) ?? 0,
        ingredients: ingredients,
      );

      if (mounted) Navigator.pop(context, newRecipe);
    }
  }

  /// Delegiert an [buildIngredientRow] aus ingredient_form.dart.
  Widget _buildIngredientRow(IngredientEntry entry) =>
      buildIngredientRow(entry: entry, ingredients: _ingredients, setState: setState);

  /// Baut das Formular mit Titel, Beschreibung, Kategorie, Dauer und Zutaten.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            const SliverAppBar.medium(
              title: Text('Neues Rezept'),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Titel *'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Bitte einen Titel eingeben.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Beschreibung *'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Bitte eine Beschreibung eingeben.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: 'Kategorie'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _durationController,
                    decoration: const InputDecoration(labelText: 'Dauer (Minuten)'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Zutaten',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._ingredients.map(_buildIngredientRow),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _ingredients.add(IngredientEntry());
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Zutat hinzufügen'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _saveRecipe,
                    child: const Text('Speichern'),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

