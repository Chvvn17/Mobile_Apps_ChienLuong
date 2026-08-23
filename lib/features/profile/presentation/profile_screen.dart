import 'package:flutter/material.dart';

/// Zeigt das Benutzerprofil mit Avatar-Platzhalter und Kontaktdaten.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  /// Baut den Profil-Screen mit Avatar, Name und E-Mail-Karte.
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text('Profil'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(Icons.person,
                        size: 48, color: colorScheme.onPrimaryContainer),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Mein Profil',
                    style: textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.person_outline,
                              color: colorScheme.primary),
                          title: const Text('Name'),
                          subtitle: const Text('–'),
                        ),
                        Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: colorScheme.outlineVariant,
                        ),
                        ListTile(
                          leading: Icon(Icons.email_outlined,
                              color: colorScheme.primary),
                          title: const Text('E-Mail'),
                          subtitle: const Text('–'),
                        ),
                      ],
                    ),
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
