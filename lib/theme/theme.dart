import 'package:flutter/material.dart';

class MyTheme {
  // 🎨 Define color palette (Pro-level for a books app: Sophisticated grays with subtle accents for readability and elegance)
  static const Color primaryColor = Color(
    0xFF37474F,
  ); // Charcoal Gray (professional, bookish depth)
  static const Color accentColor = Color(
    0xFF78909C,
  ); // Muted Blue-Gray (subtle accent for highlights, like page edges)
  static const Color backgroundColor = Color(
    0xFFFAFAFA,
  ); // Off-White (paper-like, easy on eyes for reading)
  static const Color textColor = Color(
    0xFF212121,
  ); // Dark Gray (high contrast for text, like ink)
  static const Color surfaceColor = Color(
    0xFFFFFFFF,
  ); // Pure White for cards/surfaces
  static const Color dividerColor = Color(
    0xFFB0BEC5,
  ); // Light Gray for dividers

  // 🌟 Main theme data
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,

      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        background: backgroundColor,
        surface: surfaceColor,
        onPrimary: Colors.white, // Text on primary (e.g., buttons)
        onSecondary: Colors.white,
        onBackground: textColor,
        onSurface: textColor,
      ),

      // 🧭 AppBar Theme (Elevated for a premium feel)
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 8, // Increased for depth
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22, // Slightly larger for prominence
          fontWeight: FontWeight.w600, // Semi-bold for elegance
          letterSpacing: 0.5, // Added spacing for pro look
        ),
        iconTheme: IconThemeData(color: accentColor, size: 24),
        shadowColor: Colors.black.withOpacity(0.2),
      ),

      // 🔘 Elevated Button Theme (Rounded for modern touch)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              16,
            ), // More rounded for softness
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          elevation: 6, // Added elevation for button depth
          shadowColor: primaryColor.withOpacity(0.3),
        ),
      ),

      // 🪶 Text Button Theme (Minimalist)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // 🧱 Card Theme (Book-like with subtle shadows)
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 6, // Increased for a lifted, premium feel
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // More rounded for elegance
        ),
        shadowColor: Colors.black.withOpacity(0.1), // Soft shadow
      ),

      // 📝 Text Theme (Typography inspired by books: Serif-like weights)
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: textColor,
          fontSize: 18,
          height: 1.5,
        ), // Line height for readability
        bodyMedium: TextStyle(color: textColor, fontSize: 16, height: 1.4),
        titleLarge: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700, // Bolder for headings
          fontSize: 24,
          letterSpacing: 0.5,
        ),
        titleMedium: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),

      // 🔘 Floating Action Button (Iconic for book actions like "add to library")
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Consistent rounding
        ),
      ),

      // ➖ Divider (Subtle, like page separators)
      dividerTheme: DividerThemeData(
        color: dividerColor.withOpacity(0.5),
        thickness: 1.5, // Slightly thicker for visibility
        space: 24, // More space around
      ),

      // ➕ Additional pro touches for books app
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        hintStyle: TextStyle(color: accentColor),
      ),

      // Icon theme for consistency
      iconTheme: IconThemeData(color: primaryColor, size: 24),
    );
  }
}
