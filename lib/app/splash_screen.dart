import 'package:flutter/material.dart';
import 'navigation_screen.dart';

/// Splash-Screen mit gestaffelten Einblend-Animationen und automatischer Navigation.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _iconFade;
  late final Animation<double> _iconScale;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _spinnerFade;

  /// Richtet alle Animations-Intervalle ein und startet den Timer zur Navigation.
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _iconFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0.0, 0.35, curve: Curves.easeOut)),
    );
    _iconScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0.0, 0.55, curve: Curves.elasticOut)),
    );
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0.35, 0.6, curve: Curves.easeOut)),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller,
        curve: const Interval(0.35, 0.6, curve: Curves.easeOut)));
    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0.5, 0.72, curve: Curves.easeOut)),
    );
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller,
        curve: const Interval(0.5, 0.72, curve: Curves.easeOut)));
    _spinnerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0.65, 0.85, curve: Curves.easeOut)),
    );
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const NavigationScreen(),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  /// Gibt den [AnimationController] frei.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Baut den Splash-Screen mit Gradient, animiertem Logo, Titel und Lade-Spinner.
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary,
              Color.lerp(colorScheme.primary, Colors.black, 0.28)!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: _iconFade,
                        child: ScaleTransition(
                          scale: _iconScale,
                          child: Container(
                            width: 112,
                            height: 112,
                            decoration: BoxDecoration(
                              color: colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 40,
                                  offset: const Offset(0, 14),
                                ),
                                BoxShadow(
                                  color: colorScheme.onPrimary.withValues(alpha: 0.12),
                                  blurRadius: 28,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(Icons.menu_book_rounded,
                                size: 66, color: colorScheme.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      FadeTransition(
                        opacity: _titleFade,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: Text(
                            'Kochbuch',
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeTransition(
                        opacity: _subtitleFade,
                        child: SlideTransition(
                          position: _subtitleSlide,
                          child: Text(
                            'Deine persönliche Rezeptsammlung',
                            style: TextStyle(
                              color: colorScheme.onPrimary.withValues(alpha: 0.65),
                              fontSize: 15,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FadeTransition(
                opacity: _spinnerFade,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 52),
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colorScheme.onPrimary.withValues(alpha: 0.55),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
