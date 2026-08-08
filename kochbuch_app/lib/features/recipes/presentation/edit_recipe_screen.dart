import 'package:flutter/material.dart';
import '../domain/recipe.dart';
import '../domain/ingredient.dart';

const _units = ['g', 'kg', 'ml', 'l', 'Stück'];

class _IngredientEntry {
  final TextEditingController nameController;
  final TextEditingController amountController;
  String unit;

  _IngredientEntry({String name = '', String amount = '', String unit = 'g'})
      : nameController = TextEditingController(text: name),
        amountController = TextEditingController(text: amount),
        unit = unit;

  void dispose() {
    nameController.dispose();
    amountController.dispose();
  }
}

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
  late final List<_IngredientEntry> _ingredients;

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
      return _IngredientEntry(name: i.name, amount: amount, unit: i.unit);
    }).toList();
  }

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

  void _saveRecipe() {
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
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _categoryController.text.trim().isEmpty
            ? 'Sonstiges'
            : _categoryController.text.trim(),
        durationMinutes:
            int.tryParse(_durationController.text.trim()) ?? 0,
        ingredients: ingredients,
      );
      Navigator.pop(context, updatedRecipe);
    }
  }

  Widget _buildIngredientRow(_IngredientEntry entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 60,
            child: TextField(
              controller: entry.amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Menge'),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: entry.unit,
            items: _units
                .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => entry.unit = val);
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: entry.nameController,
              decoration: const InputDecoration(labelText: 'Zutat'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: () {
              setState(() {
                _ingredients.remove(entry);
                entry.dispose();
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezept bearbeiten'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                decoration:
                    const InputDecoration(labelText: 'Dauer (Minuten)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              const Text(
                'Zutaten',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._ingredients.map(_buildIngredientRow),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _ingredients.add(_IngredientEntry());
                  });
                },
                icon: const Icon(Icons.add, color: Colors.orange),
                label: const Text(
                  'Zutat hinzufügen',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveRecipe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Speichern'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

