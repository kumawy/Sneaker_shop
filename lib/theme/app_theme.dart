import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1A1A2E); // deep navy
  static const Color primaryLight = Color(0xFF16213E);
  static const Color primaryLighter = Color(0xFF2A2A5E); // lighter navy
  static const Color accent = Color(0xFFE94560); // pixel red
  static const Color accentGreen = Color(0xFF0F3460); // pixel dark blue
  static const Color pixelYellow = Color(0xFFF5A623); // retro amber
  static const Color pixelGreen = Color(0xFF4CAF50); // classic green
  static const Color pixelPurple = Color(0xFF9C27B0); // retro purple
  static const Color pixelCyan = Color(0xFF00BCD4); // retro cyan
  static const Color pixelOrange = Color(0xFFFF5722); // retro orange

  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8F4F0); // warm off-white
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textGrey = Color(0xFF666680);
  static const Color divider = Color(0xFFD0CCC8);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color surfaceBg = Color(0xFFF8F4F0);

  static const Color darkBg = Color(0xFF0D0D1A);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF1E1E35);
  static const Color darkBorder = Color(0xFF333355);
  static const Color darkText = Color(0xFFE8E8F8);
  static const Color darkTextGrey = Color(0xFF8888AA);
}

class AppTheme {
  static const _buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );

  static ThemeData get lightTheme => _build(Brightness.light);
  static ThemeData get darkTheme => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = isDark
        ? ColorScheme.dark(
            primary: AppColors.accent,
            secondary: AppColors.pixelYellow,
            surface: AppColors.darkCard,
            onPrimary: AppColors.white,
            onSurface: AppColors.darkText,
            outline: AppColors.darkBorder,
          )
        : ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.accent,
            surface: AppColors.cardBg,
            onPrimary: AppColors.white,
            onSurface: AppColors.textDark,
            outline: AppColors.divider,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? AppColors.darkBg : AppColors.surfaceBg,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.cardBg,
        foregroundColor: isDark ? AppColors.white : AppColors.textDark,
        elevation: 0,
        centerTitle: false,
        shadowColor: AppColors.accent,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: isDark ? 0 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.divider,
            width: 1,
          ),
        ),
        color: isDark ? AppColors.darkCard : AppColors.cardBg,
        margin: const EdgeInsets.all(0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.accent : AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: _buttonShape,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? AppColors.accent : AppColors.primary,
          elevation: 0,
          shape: _buttonShape,
          side: BorderSide(
            color: isDark ? AppColors.accent : AppColors.primary,
            width: 1.4,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDark ? AppColors.accent : AppColors.primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.divider,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.accent : AppColors.accent,
            width: 1.5,
          ),
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : AppColors.white,
        labelStyle: TextStyle(
          color: isDark ? AppColors.darkTextGrey : AppColors.textGrey,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.offWhite,
        selectedColor: isDark ? AppColors.accent : AppColors.primary,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.cardBg,
        indicatorColor: AppColors.accent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.white
                : selected
                    ? AppColors.textDark
                    : AppColors.textGrey,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.white);
          }
          return IconThemeData(
            color: isDark ? AppColors.darkTextGrey : AppColors.textGrey,
          );
        }),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.darkBorder : AppColors.divider,
        thickness: 1,
        space: 2,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.primary,
        contentTextStyle: const TextStyle(
          color: AppColors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: isDark ? AppColors.darkText : AppColors.textDark,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: isDark ? AppColors.darkText : AppColors.textDark,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: isDark ? AppColors.darkText : AppColors.textDark,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: isDark ? AppColors.darkText : AppColors.textDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: isDark ? AppColors.darkText : AppColors.textDark,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: isDark ? AppColors.darkTextGrey : AppColors.textGrey,
        ),
      ),
    );
  }
}
