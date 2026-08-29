import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kcPrimaryColor,
        primary: kcPrimaryColor,
        secondary: kcPrimaryColorLight,
        surface: kcSurfaceColor,
      ),
      scaffoldBackgroundColor: kcBackgroundColor,
      fontFamily: 'sans-serif',
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displaySmall: const TextStyle(
          color: kcDarkGreyColor,
          fontSize: 30,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
        ),
        headlineMedium: const TextStyle(
          color: kcDarkGreyColor,
          fontSize: 26,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
        titleLarge: const TextStyle(
          color: kcDarkGreyColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: const TextStyle(
          color: kcDarkGreyColor,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: const TextStyle(
          color: kcDarkGreyColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: const TextStyle(
          color: kcMediumGrey,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: const TextStyle(
          color: kcLightGrey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kcSurfaceColor,
        hintStyle: const TextStyle(
          color: kcLightGrey,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: kcBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: kcBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: kcPrimaryColor, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: kcErrorColor),
        ),
      ),
      cardTheme: CardThemeData(
        color: kcSurfaceColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: kcVeryLightGrey),
        ),
      ),
      dividerColor: kcVeryLightGrey,
    );
  }
}
