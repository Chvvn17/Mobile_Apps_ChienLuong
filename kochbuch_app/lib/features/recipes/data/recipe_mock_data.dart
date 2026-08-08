import '../domain/recipe.dart';
import '../domain/ingredient.dart';

const mockRecipes = [
  Recipe(
    title: 'Spaghetti Carbonara',
    description: 'Klassische italienische Pasta mit Ei, Speck und Parmesan.',
    category: 'Pasta',
    durationMinutes: 25,
    ingredients: [
      Ingredient(name: 'Spaghetti', amount: 400, unit: 'g'),
      Ingredient(name: 'Speck', amount: 150, unit: 'g'),
      Ingredient(name: 'Eier', amount: 3, unit: 'Stück'),
      Ingredient(name: 'Parmesan', amount: 80, unit: 'g'),
    ],
  ),
  Recipe(
    title: 'Gemüsesuppe',
    description: 'Einfache Suppe mit Karotten, Sellerie und Kartoffeln.',
    category: 'Suppe',
    durationMinutes: 40,
    ingredients: [
      Ingredient(name: 'Karotten', amount: 300, unit: 'g'),
      Ingredient(name: 'Sellerie', amount: 200, unit: 'g'),
      Ingredient(name: 'Kartoffeln', amount: 400, unit: 'g'),
      Ingredient(name: 'Gemüsebrühe', amount: 1, unit: 'l'),
    ],
  ),
  Recipe(
    title: 'Pfannkuchen',
    description: 'Einfache Pfannkuchen mit Mehl, Ei und Milch.',
    category: 'Frühstück',
    durationMinutes: 20,
    ingredients: [
      Ingredient(name: 'Mehl', amount: 200, unit: 'g'),
      Ingredient(name: 'Milch', amount: 300, unit: 'ml'),
      Ingredient(name: 'Eier', amount: 2, unit: 'Stück'),
      Ingredient(name: 'Butter', amount: 20, unit: 'g'),
    ],
  ),
  Recipe(
    title: 'Avocado Toast',
    description: 'Geröstetes Brot mit Avocado, Salz und Zitronensaft.',
    category: 'Frühstück',
    durationMinutes: 10,
    ingredients: [
      Ingredient(name: 'Brot', amount: 2, unit: 'Stück'),
      Ingredient(name: 'Avocado', amount: 1, unit: 'Stück'),
      Ingredient(name: 'Zitronensaft', amount: 10, unit: 'ml'),
    ],
  ),
  Recipe(
    title: 'Tomatensalat',
    description: 'Frischer Salat mit Tomaten, Basilikum und Olivenöl.',
    category: 'Salat',
    durationMinutes: 10,
    ingredients: [
      Ingredient(name: 'Tomaten', amount: 500, unit: 'g'),
      Ingredient(name: 'Olivenöl', amount: 30, unit: 'ml'),
    ],
  ),
];
