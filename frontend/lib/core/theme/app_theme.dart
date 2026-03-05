import 'package:flutter/material.dart';

/// KriptoGraf Finans Premium Dark Theme
/// 
/// Tutarlı renk paleti, özel font boyutları ve premium hissi.
class AppTheme {
  // ── Renk Paleti ──
  static const Color bg = Color(0xFF0A0E17);
  static const Color surface = Color(0xFF0D1117);
  static const Color surfaceLight = Color(0xFF161B22);
  static const Color border = Color(0xFF21262D);
  static const Color borderLight = Color(0xFF30363D);
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color accent = Color(0xFF58A6FF);
  static const Color accentDark = Color(0xFF1F6FEB);
  static const Color green = Color(0xFF00E676);
  static const Color greenDark = Color(0xFF089981);
  static const Color red = Color(0xFFF23645);
  static const Color orange = Color(0xFFFF9800);
  static const Color pink = Color(0xFFF778BA);
  static const Color purple = Color(0xFF7B2FF7);
  static const Color cyan = Color(0xFF00D2FF);
  static const Color gold = Color(0xFFFFD700);

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF58A6FF),
        brightness: Brightness.dark,
        surface: surface,
      ),
      useMaterial3: true,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: -0.5),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: textPrimary),
        headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: textPrimary),
        headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary),
        bodyLarge: TextStyle(fontSize: 14, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 12, color: textSecondary),
        bodySmall: TextStyle(fontSize: 10, color: textSecondary),
        labelLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        labelSmall: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: textSecondary),
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: border.withOpacity(0.6)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: border.withOpacity(0.6),
        thickness: 1,
      ),
      tabBarTheme: TabBarTheme(
        indicatorColor: accent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: accent,
        unselectedLabelColor: textSecondary,
        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
      ),
    );
  }

  /// Glassmorphism kart dekorasyonu
  static BoxDecoration glassCard({Color? borderColor}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          surfaceLight.withOpacity(0.9),
          surface.withOpacity(0.7),
        ],
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: borderColor ?? border.withOpacity(0.5),
      ),
    );
  }

  /// Glow efektli container
  static BoxDecoration glowContainer(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.3)),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.1),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ],
    );
  }
}
