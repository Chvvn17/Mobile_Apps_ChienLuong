# Kochbuch-App – Projektdokumentation

## Projektübersicht

| Eigenschaft | Wert |
|---|---|
| App-Name | Kochbuch-App |
| Framework | Flutter (Dart) |
| Plattform | Android, iOS |
| Backend | Firebase (Firestore + Authentication) |
| Modul | Mobile App Development |

Die Kochbuch-App ermöglicht es, eigene Rezepte zu erfassen, zu bearbeiten, zu löschen und wieder zu finden. Jeder Benutzer sieht nur seine eigenen Rezepte, die dauerhaft in der Cloud gespeichert werden.

---

## App-Struktur

```
lib/
├── main.dart                          # Einstiegspunkt, Firebase-Init, anonymer Login
├── firebase_options.dart              # Automatisch generierte Firebase-Konfiguration
├── app/
│   ├── app.dart                       # MaterialApp mit Material-3-Theme (Amber)
│   ├── splash_screen.dart             # Animierter Splash-Screen beim Start
│   └── navigation_screen.dart         # NavigationBar mit 4 Tabs
└── features/
    ├── recipes/
    │   ├── domain/
    │   │   ├── recipe.dart            # Datenmodell: Recipe
    │   │   └── ingredient.dart        # Datenmodell: Ingredient
    │   ├── data/
    │   │   ├── recipes_collection.dart # Hilfsfunktion: benutzerbezogene Firestore-Collection
    │   │   └── recipe_mock_data.dart  # Testdaten (Entwicklung)
    │   └── presentation/
    │       ├── recipe_list_screen.dart  # Übersicht aller Rezepte
    │       ├── recipe_detail_screen.dart # Detailansicht eines Rezepts
    │       ├── add_recipe_screen.dart   # Neues Rezept erfassen
    │       ├── edit_recipe_screen.dart  # Bestehendes Rezept bearbeiten
    │       └── ingredient_form.dart    # Zutaten-Eingabeformular
    ├── shopping/
    │   └── presentation/
    │       └── shopping_list_screen.dart
    ├── info/
    │   └── presentation/
    │       └── info_screen.dart
    └── profile/
        └── presentation/
            └── profile_screen.dart

assets/
└── images/
    └── placeholder.png               # Platzhalterbild für Rezeptliste
```

---

## Navigation

Die App nutzt eine `NavigationBar` (Material 3) mit vier Tabs:

| Tab | Screen | Icon |
|---|---|---|
| Rezepte | `RecipeListScreen` | restaurant_menu |
| Einkaufsliste | `ShoppingListScreen` | shopping_cart |
| Info | `InfoScreen` | info |
| Profil | `ProfileScreen` | person |

Beim Start wird der `SplashScreen` mit gestaffelten Einblend-Animationen angezeigt, bevor zur `NavigationScreen` weitergeleitet wird.

---

## Datenmodelle

### Recipe
```dart
class Recipe {
  final String id;             // Firestore Document-ID
  final String title;
  final String description;
  final String category;
  final int durationMinutes;
  final List<Ingredient> ingredients;
}
```

### Ingredient
```dart
class Ingredient {
  final String name;
  final double amount;
  final String unit;
}
```

---

## Firebase-Integration

### Firestore

Rezepte werden benutzerbezogen gespeichert unter:
```
users/{userId}/recipes/{documentId}
```

Die Hilfsfunktion `recipesCollection()` in `recipes_collection.dart` gibt immer die Collection des aktuell angemeldeten Benutzers zurück:

```dart
CollectionReference recipesCollection() {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('recipes');
}
```

### CRUD-Operationen

| Operation | Methode | Screen |
|---|---|---|
| Read | `recipesCollection().get()` | `RecipeListScreen` (beim Start) |
| Create | `recipesCollection().add(...)` | `AddRecipeScreen` |
| Update | `recipesCollection().doc(id).update(...)` | `EditRecipeScreen` |
| Delete | `recipesCollection().doc(id).delete()` | `RecipeDetailScreen` |

### Firebase Authentication

Die App meldet sich beim Start anonym an (`signInAnonymously()`). Dadurch erhält jeder Benutzer eine eindeutige `uid`, die als Firestore-Pfad verwendet wird.

```dart
await FirebaseAuth.instance.signInAnonymously();
```

### Firestore Rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;
    }
  }
}
```

---

## Packages

| Package | Version | Verwendung |
|---|---|---|
| `firebase_core` | ^4.13.0 | Firebase initialisieren |
| `cloud_firestore` | ^6.8.0 | Datenbank (Rezepte speichern/laden) |
| `firebase_auth` | ^6.5.7 | Anonyme Benutzer-Authentifizierung |
| `intl` | ^0.20.3 | Korrekte Singular/Plural-Anzeige der Zubereitungszeit |
| `cupertino_icons` | ^1.0.8 | iOS-Icons |

### intl – Verwendung im Code

Das Package `intl` wird in `recipe_detail_screen.dart` eingesetzt, um die Zubereitungszeit korrekt anzuzeigen:

```dart
import 'package:intl/intl.dart';

String formatDuration(int minutes) {
  return Intl.plural(
    minutes,
    one: '1 Minute',
    other: '$minutes Minuten',
    locale: 'de',
  );
}
```

---

## Assets

| Datei | Pfad | Verwendung |
|---|---|---|
| `placeholder.png` | `assets/images/placeholder.png` | Platzhalterbild in der Rezeptliste |

Registriert in `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/images/
```

Verwendet in `recipe_list_screen.dart`:
```dart
Image.asset(
  'assets/images/placeholder.png',
  width: 48,
  height: 48,
  fit: BoxFit.cover,
)
```

---

## Entwicklungsschritte (nach Kurstagen)

| Kurstag | Thema | Was umgesetzt wurde |
|---|---|---|
| KT 1 | Flutter-Grundlagen | Projektidee Kochbuch-App definiert |
| KT 2–4 | Widgets & Layouts | Grundstruktur, Screens, Navigation |
| KT 5–7 | State Management | `StatefulWidget`, `setState`, Formulare |
| KT 8–10 | Firebase Setup | Firebase-Projekt, Firestore-Collection, einfaches Read |
| KT 11 | Cloud CRUD | Vollständiges Create/Read/Update/Delete mit Firestore |
| KT 12 | Firebase Auth | Anonymer Login, benutzerbezogene Collection `users/{uid}/recipes`, Firestore Rules |
| KT 13 | pubspec.yaml, Packages & Assets | `intl` installiert und genutzt, `placeholder.png` als Asset eingebunden |

---

## Wichtige Befehle

```bash
# Packages installieren
flutter pub get

# Package hinzufügen
flutter pub add <packagename>

# App starten
flutter run

# Code analysieren
flutter analyze
```
