import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InkColors {
  static const voidBlack = Color(0xFF07090A);
  static const newsroom = Color(0xFF10161A);
  static const teal = Color(0xFF1C3D42);
  static const tealDeep = Color(0xFF0E2428);
  static const brass = Color(0xFFC4A574);
  static const brassDim = Color(0xFF8A734C);
  static const paper = Color(0xFFE6D7C3);
  static const paperDim = Color(0xFFC9B79A);
  static const blood = Color(0xFF8E2F2F);
  static const ink = Color(0xFF161310);
}

class NightDeskTheme {
  static ThemeData get dark {
    final serif = GoogleFonts.cormorantGaramondTextTheme(ThemeData.dark().textTheme);
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: InkColors.voidBlack,
      colorScheme: const ColorScheme.dark(
        primary: InkColors.brass,
        secondary: InkColors.blood,
        surface: InkColors.newsroom,
      ),
      textTheme: serif.copyWith(
        displayLarge: GoogleFonts.cormorantGaramond(
          fontSize: 48,
          fontWeight: FontWeight.w600,
          color: InkColors.paper,
          height: 0.95,
          decoration: TextDecoration.none,
        ),
        displayMedium: GoogleFonts.cormorantGaramond(
          fontSize: 34,
          fontWeight: FontWeight.w600,
          color: InkColors.paper,
          decoration: TextDecoration.none,
        ),
        titleMedium: GoogleFonts.specialElite(
          fontSize: 13,
          letterSpacing: 3.2,
          color: InkColors.brass,
          decoration: TextDecoration.none,
        ),
        bodyLarge: GoogleFonts.cormorantGaramond(
          fontSize: 20,
          height: 1.35,
          color: InkColors.paper,
          decoration: TextDecoration.none,
        ),
        bodyMedium: GoogleFonts.cormorantGaramond(
          fontSize: 17,
          height: 1.4,
          color: InkColors.paperDim,
          decoration: TextDecoration.none,
        ),
        labelLarge: GoogleFonts.specialElite(
          fontSize: 12,
          letterSpacing: 2,
          color: InkColors.brass,
          decoration: TextDecoration.none,
        ),
      ).apply(
        decoration: TextDecoration.none,
      ),
      useMaterial3: true,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          overlayColor: Colors.transparent,
          foregroundColor: InkColors.brass,
          textStyle: const TextStyle(
            decoration: TextDecoration.none,
            decorationColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
