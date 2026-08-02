import 'package:flutter/material.dart';

// ─── Excelerate Brand Colors ────────────────────────────────────────────────
class ExColors {
  // Primary gradient: orange → pink/magenta
  static const Color orange = Color(0xFFFF5722);
  static const Color pink = Color(0xFFE91E8C);
  static const Color red = Color(0xFFE53935);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF121212);
  static const Color surface = Color(0xFFF8F4F4);
  static const Color surfaceDark = Color(0xFF1E1A1A);
  static const Color cardDark = Color(0xFF2A2424);

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textLight = Color(0xFFFFFFFF);

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [orange, pink],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient primaryGradientDiagonal = LinearGradient(
    colors: [orange, red, pink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ─── Theme Data ──────────────────────────────────────────────────────────────
class ExTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ExColors.orange,
        brightness: Brightness.light,
        primary: ExColors.orange,
        secondary: ExColors.pink,
        surface: ExColors.surface,
      ),
      scaffoldBackgroundColor: ExColors.surface,
      cardColor: ExColors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: ExColors.white,
        foregroundColor: ExColors.textPrimary,
        elevation: 0,
        surfaceTintColor: ExColors.white,
        titleTextStyle: TextStyle(
          color: ExColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: ExColors.textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ExColors.orange,
          foregroundColor: ExColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ExColors.orange,
          side: const BorderSide(color: ExColors.orange, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ExColors.orange,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ExColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: ExColors.orange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ExColors.error),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ExColors.white,
        selectedItemColor: ExColors.orange,
        unselectedItemColor: Color(0xFF9E9E9E),
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: ExColors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ExColors.orange;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ExColors.orange.withOpacity(0.3);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ExColors.orange,
        linearTrackColor: Color(0xFFFFE0D6),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: ExColors.orange,
        unselectedLabelColor: Color(0xFF9E9E9E),
        indicatorColor: ExColors.orange,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ExColors.orange,
        brightness: Brightness.dark,
        primary: ExColors.orange,
        secondary: ExColors.pink,
        surface: ExColors.surfaceDark,
      ),
      scaffoldBackgroundColor: ExColors.black,
      cardColor: ExColors.cardDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: ExColors.surfaceDark,
        foregroundColor: ExColors.white,
        elevation: 0,
        surfaceTintColor: ExColors.surfaceDark,
        titleTextStyle: TextStyle(
          color: ExColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: ExColors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ExColors.orange,
          foregroundColor: ExColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ExColors.orange,
          side: const BorderSide(color: ExColors.orange, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ExColors.orange,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ExColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: ExColors.orange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ExColors.error),
        ),
        hintStyle: const TextStyle(color: Color(0xFF666666)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ExColors.surfaceDark,
        selectedItemColor: ExColors.orange,
        unselectedItemColor: Color(0xFF666666),
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A2A2A),
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: ExColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ExColors.orange;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ExColors.orange.withOpacity(0.3);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: ExColors.orange,
        linearTrackColor: ExColors.orange.withOpacity(0.15),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: ExColors.orange,
        unselectedLabelColor: Color(0xFF666666),
        indicatorColor: ExColors.orange,
      ),
    );
  }
}
