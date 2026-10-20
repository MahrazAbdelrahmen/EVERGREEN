import 'package:flutter/material.dart';

/// Brand palette from the project's "charte graphique".
abstract final class AppColors {
  static const lightBlue = Color(0xFF4CDAFE);
  static const darkBeige = Color(0xFFFFD217);
  static const green = Color(0xFF67EB00);
  static const lightPurple = Color(0xFFDD67ED);
}

const _fontFamily = 'Digital';

final ThemeData appTheme = () {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.green,
    primary: const Color(0xFF3A8F00),
    secondary: AppColors.lightBlue,
    tertiary: AppColors.lightPurple,
  );
  final rounded = RoundedRectangleBorder(borderRadius: BorderRadius.circular(20));

  return ThemeData(
    colorScheme: colorScheme,
    fontFamily: _fontFamily,
    scaffoldBackgroundColor: Colors.white,
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        for (final platform in TargetPlatform.values) platform: PlayfulPageTransitionsBuilder(),
      },
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.lightBlue,
        textStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.bold,
        ),
        shape: rounded,
      ),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentTextStyle: const TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedLabelStyle: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontFamily: _fontFamily),
    ),
  );
}();

/// Screen transition used across the app: the new screen fades in while
/// gently zooming up, and the old one recedes slightly behind it.
class PlayfulPageTransitionsBuilder extends PageTransitionsBuilder {
  const PlayfulPageTransitionsBuilder();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 380);

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final incoming = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
    final outgoing = CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: incoming,
      child: ScaleTransition(
        scale: Tween(begin: 0.94, end: 1.0).animate(incoming),
        child: ScaleTransition(
          scale: Tween(begin: 1.0, end: 0.97).animate(outgoing),
          child: child,
        ),
      ),
    );
  }
}
