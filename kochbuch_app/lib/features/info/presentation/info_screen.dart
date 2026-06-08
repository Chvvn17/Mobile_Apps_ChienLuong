import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meine Kochbuch-App',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Diese App hilft dir dabei, deine Lieblingsrezepte übersichtlich zu verwalten. '
              'Du kannst Rezepte ansehen, Details abrufen und deine Einkaufsliste planen.',
            ),
            SizedBox(height: 16),
            Text('Version: 1.0.0'),
          ],
        ),
      ),
    );
  }
}
