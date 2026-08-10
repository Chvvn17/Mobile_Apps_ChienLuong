import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Zeigt allgemeine Informationen zur App wie Name und Version.
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  /// Baut den Info-Screen mit Versions-Karte und App-Beschreibung.
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text('Info'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.menu_book_rounded,
                            size: 40, color: colorScheme.onPrimaryContainer),
                        const SizedBox(height: 12),
                        Text(
                          'Meine Kochbuch-App',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Version 1.0.0',
                            style: TextStyle(
                                color: colorScheme.onPrimaryContainer)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Über die App',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Diese App hilft dir dabei, deine Lieblingsrezepte übersichtlich zu verwalten. '
                        'Du kannst Rezepte ansehen, Details abrufen und deine Einkaufsliste planen.',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Einträge aus Firestore',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('entries')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Fehler: ${snapshot.error}');
                      }
                      final docs = snapshot.data?.docs ?? [];
                      if (docs.isEmpty) {
                        return const Text('Keine Einträge gefunden.');
                      }
                      return Column(
                        children: docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return Card(
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                  color: colorScheme.outlineVariant),
                            ),
                            child: ListTile(
                              title: Text(data['title'] ?? ''),
                              subtitle: Text(data['description'] ?? ''),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
