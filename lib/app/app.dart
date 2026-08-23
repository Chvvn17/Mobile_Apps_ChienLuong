import 'package:flutter/material.dart';
import 'splash_screen.dart';

/// Wurzel-Widget der App mit Material-3-Theme und Splash Screen als Startseite.
class App extends StatelessWidget {
  const App({super.key});

  /// Erstellt die [MaterialApp] mit Amber-Farbschema und [SplashScreen] als Home.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meine Kochbuch-App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8F00)),
      ),
      home: const SplashScreen(),
    );
  }
}
