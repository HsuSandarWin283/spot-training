import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminColors {
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color card = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF7C7CFF);
  static const Color secondary = Color(0xFF00E5B8);
  static const Color accent = Color(0xFFFF6B6B);
  static const Color border = Color(0xFFE0E0E0);
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF000000);
  static const Color textMuted = Color(0xFF000000);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C7CFF), Color(0xFFB14EFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFF87171)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AdminTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AdminColors.background,
      primaryColor: AdminColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AdminColors.primary,
        secondary: AdminColors.secondary,
        surface: AdminColors.surface,
        error: AdminColors.error,
      ),
      textTheme: GoogleFonts.notoSansTextTheme(ThemeData.light().textTheme),
      iconTheme: const IconThemeData(color: Colors.black),
      appBarTheme: const AppBarTheme(
        backgroundColor: AdminColors.surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AdminColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AdminColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AdminColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AdminColors.border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AdminColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AdminColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AdminColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AdminColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AdminColors.error),
        ),
        labelStyle: const TextStyle(color: AdminColors.textSecondary),
        hintStyle: const TextStyle(color: AdminColors.textMuted),
        prefixIconColor: AdminColors.textMuted,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AdminColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.notoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AdminColors.primary,
          side: const BorderSide(color: AdminColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(AdminColors.surface),
        dataRowColor: WidgetStateProperty.all(Colors.transparent),
        headingTextStyle: const TextStyle(
          color: AdminColors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        dataTextStyle: const TextStyle(
          color: AdminColors.textPrimary,
          fontSize: 14,
        ),
        dividerThickness: 0.5,
      ),
      dividerTheme: const DividerThemeData(
        color: AdminColors.border,
        thickness: 0.5,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AdminColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AdminColors.border),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AdminColors.surface,
        contentTextStyle: const TextStyle(color: AdminColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AdminColors.border),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
