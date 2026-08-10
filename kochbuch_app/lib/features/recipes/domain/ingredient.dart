/// Datenmodell für eine einzelne Zutat mit Mengenangabe und Einheit.
class Ingredient {
  final String name;
  final double amount;
  final String unit;

  /// Erstellt eine Zutat mit Name, Menge (z. B. 200.0) und Einheit (z. B. 'g').
  const Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
  });
}
