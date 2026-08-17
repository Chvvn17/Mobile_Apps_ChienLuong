import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../domain/recipe.dart';
import '../domain/ingredient.dart';
import 'ingredient_form.dart';

/// Formular zum Bearbeiten eines bestehenden Rezeptes mit vorbefüllten Feldern.
class EditRecipeScreen extends StatefulWidget {
  final Recipe recipe;

  const EditRecipeScreen({super.key, required this.recipe});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _durationController;
  late final List<IngredientEntry> _ingredients;

  /// Befüllt alle Controller mit den vorhandenen Rezeptdaten.
  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.recipe.title);
    _descriptionController =
        TextEditingController(text: widget.recipe.description);
    _categoryController =
        TextEditingController(text: widget.recipe.category);
    _durationController = TextEditingController(
        text: widget.recipe.durationMinutes.toString());
    _ingredients = widget.recipe.ingredients.map((i) {
      final amount = i.amount % 1 == 0
          ? i.amount.toInt().toString()
          : i.amount.toString();
      return IngredientEntry(name: i.name, amount: amount, unit: i.unit);
    }).toList();
  }

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

  /// Validiert das Formular, speichert Änderungen in Firestore und gibt das aktualisierte [Recipe] zurück.
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

      final updatedRecipe = Recipe(
        id: widget.recipe.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _categoryController.text.trim().isEmpty
            ? 'Sonstiges'
            : _categoryController.text.trim(),
        durationMinutes:
            int.tryParse(_durationController.text.trim()) ?? 0,
        ingredients: ingredients,
      );

      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.recipe.id)
          .update({
            'title': updatedRecipe.title,
            'description': updatedRecipe.description,
            'category': updatedRecipe.category,
            'durationMinutes': updatedRecipe.durationMinutes,
            'ingredients': updatedRecipe.ingredients
                .map((i) => {
                      'name': i.name,
                      'amount': i.amount,
                      'unit': i.unit,
                    })
                .toList(),
          });

      if (mounted) Navigator.pop(context, updatedRecipe);
    }
  }

  /// Delegiert an [buildIngredientRow] aus ingredient_form.dart.
  Widget _buildIngredientRow(IngredientEntry entry) =>
      buildIngredientRow(entry: entry, ingredients: _ingredients, setState: setState);

  /// Baut das Formular mit vorbefüllten Feldern für das zu bearbeitende Rezept.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            const SliverAppBar.medium(
              title: Text('Rezept bearbeiten'),
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

