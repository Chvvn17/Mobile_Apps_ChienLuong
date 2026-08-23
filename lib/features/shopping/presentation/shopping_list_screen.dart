import 'package:flutter/material.dart';

/// Platzhalter-Screen für die noch nicht implementierte Einkaufsliste.
class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  /// Zeigt einen leeren Zustand bis die Einkaufsliste implementiert ist.
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text('Einkaufsliste'),
          ),
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 64, color: colorScheme.outlineVariant),
                  const SizedBox(height: 16),
                  Text(
                    'Einkaufsliste kommt bald.',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

