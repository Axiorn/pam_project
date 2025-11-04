import 'package:flutter/material.dart';

class AppTheme {
  static const Color _seedColor = Color(0xFF2979FF);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'SF-Pro-Text',

    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: const Color(0xFFF2F4FA),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
      titleLarge:
          TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.black),
      headlineSmall:
          TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
    ),

    cardColor: Colors.white,
    // cardTheme: CardTheme(
    //   surfaceTintColor: Colors.white, // FIX: ganti dari 'color:' agar tidak error
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    //   elevation: 6,
    //   margin: EdgeInsets.zero,
    // ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle:
          TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black87),
      actionsIconTheme: IconThemeData(color: Colors.black87),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: _seedColor,
      unselectedItemColor: Colors.grey.shade600,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _seedColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        elevation: 3,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _seedColor,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _seedColor,
      foregroundColor: Colors.white,
      elevation: 6,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF7F8FB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      hintStyle: TextStyle(color: Colors.black.withOpacity(0.45)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
    dividerTheme:
        DividerThemeData(color: Colors.grey.shade300, thickness: 1),
    shadowColor: Colors.black.withOpacity(0.06),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'SF-Pro-Text',

    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),

    scaffoldBackgroundColor: const Color(0xFF121212),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
      titleLarge:
          TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white),
      headlineSmall:
          TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
    ),

    cardColor: const Color(0xFF1E1E1E),
    // cardTheme: CardTheme(
    //   surfaceTintColor: const Color(0xFF1E1E1E), // FIXED
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    //   elevation: 4,
    //   margin: EdgeInsets.zero,
    // ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle:
          TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF181818),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _seedColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        elevation: 2,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _seedColor,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _seedColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.45)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    dividerTheme:
        const DividerThemeData(color: Color(0xFF2B2B2B), thickness: 1),
    shadowColor: Colors.black.withOpacity(0.3),
  );
}