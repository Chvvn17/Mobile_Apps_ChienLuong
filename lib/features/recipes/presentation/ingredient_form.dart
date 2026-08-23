import 'package:flutter/material.dart';

const ingredientUnits = ['g', 'kg', 'ml', 'l', 'Stück'];

/// Verwaltet die Eingabefelder einer Zutatenzeile im Rezeptformular.
class IngredientEntry {
  final TextEditingController nameController;
  final TextEditingController amountController;
  String unit;

  /// Erstellt einen Eintrag mit optionalen Startwerten für Name, Menge und Einheit.
  IngredientEntry({String name = '', String amount = '', this.unit = 'g'})
      : nameController = TextEditingController(text: name),
        amountController = TextEditingController(text: amount);

  /// Gibt die beiden [TextEditingController] frei.
  void dispose() {
    nameController.dispose();
    amountController.dispose();
  }
}

/// Erstellt eine Formularzeile mit Menge, Einheit-Dropdown, Zutatenname und Löschen-Button.
/// [setState] muss die setState-Methode des aufrufenden Widgets übergeben werden.
Widget buildIngredientRow({
  required IngredientEntry entry,
  required List<IngredientEntry> ingredients,
  required void Function(void Function()) setState,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 60,
          child: TextField(
            controller: entry.amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Menge'),
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: entry.unit,
          items: ingredientUnits
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
              ingredients.remove(entry);
              entry.dispose();
            });
          },
        ),
      ],
    ),
  );
}
