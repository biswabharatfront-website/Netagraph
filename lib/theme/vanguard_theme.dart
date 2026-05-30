import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VanguardTheme {
  // Theme Colors
  static const Color background = Color(0xFF0C1321);
  static const Color surface = Color(0xFF0C1321);
  static const Color surfaceElevated = Color(0xFF1A2232); // Card base depth
  static const Color surfaceContainerHigh = Color(0xFF232A39); // Input fields
  static const Color surfaceBright = Color(0xFF323949);
  
  static const Color primary = Color(0xFFFFB690);
  static const Color primaryContainer = Color(0xFFF97316); // Brand Orange
  static const Color secondary = Color(0xFFFFB3AD);
  
  static const Color actionGradientStart = Color(0xFFEF4444); // Red
  static const Color actionGradientEnd = Color(0xFFF97316); // Orange
  
  static const Color success = Color(0xFF22C55E); // Resolved green
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  
  static const Color slate = Color(0xFF64748B); // Muted metadata
  static const Color onSurface = Color(0xFFDCE2F6); // High contrast text
  static const Color onSurfaceVariant = Color(0xFFE0C0B1); // Muted peach-beige
  
  // Custom Gradients
  static const LinearGradient actionGradient = LinearGradient(
    colors: [actionGradientStart, actionGradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient darkHeroGradient = LinearGradient(
    colors: [
      Color(0x660C1321),
      Color(0xE60C1321),
      Color(0xFF0C1321),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Border Radii
  static const double radiusSmall = 4.0;
  static const double radiusDefault = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  static BorderRadius get borderSmall => BorderRadius.circular(radiusSmall);
  static BorderRadius get borderDefault => BorderRadius.circular(radiusDefault);
  static BorderRadius get borderMedium => BorderRadius.circular(radiusMedium);
  static BorderRadius get borderLarge => BorderRadius.circular(radiusLarge);
  static BorderRadius get borderXLarge => BorderRadius.circular(radiusXLarge);

  // Glow Shadow for buttons
  static List<BoxShadow> get buttonGlow => [
    BoxShadow(
      color: actionGradientStart.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get cardBorderGlow => [
    BoxShadow(
      color: Colors.white.withOpacity(0.05),
      spreadRadius: 1,
      blurRadius: 0,
      offset: const Offset(0, 0),
    ),
  ];

  // ThemeData Definition
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryContainer,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surfaceElevated,
        error: error,
      ),
      
      // Text Theme mapping to Sora and Inter
      textTheme: TextTheme(
        // Display - 40px Bold Sora
        displayLarge: GoogleFonts.sora(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          height: 1.2,
          letterSpacing: -0.8,
          color: onSurface,
        ),
        // Headline LG - 32px Semibold Sora
        headlineLarge: GoogleFonts.sora(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          height: 1.25,
          color: onSurface,
        ),
        // Headline MD - 24px Semibold Sora
        headlineMedium: GoogleFonts.sora(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.33,
          color: onSurface,
        ),
        // Body LG - 18px Regular Inter
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          height: 1.55,
          color: onSurface,
        ),
        // Body MD - 16px Regular Inter
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
          color: onSurface,
        ),
        // Label MD - 14px Semibold Inter
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          height: 1.43,
          letterSpacing: 0.14,
          color: onSurface,
        ),
        // Label SM - 12px Medium Inter
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.33,
          letterSpacing: 0.6,
          color: slate,
        ),
      ),
      
      // Button Theme
      buttonTheme: const ButtonThemeData(
        buttonColor: primaryContainer,
        textTheme: ButtonTextTheme.primary,
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: borderMedium,
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerHigh,
        hintStyle: GoogleFonts.inter(fontSize: 14, color: slate),
        labelStyle: GoogleFonts.inter(fontSize: 14, color: onSurface),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: borderDefault,
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderDefault,
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderDefault,
          borderSide: const BorderSide(color: primaryContainer, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderDefault,
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: borderMedium,
          side: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        elevation: 0,
      ),
    );
  }
}
