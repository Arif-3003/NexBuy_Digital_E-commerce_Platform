import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFFF8FC), // 🔥 soft global bg
    primaryColor: Colors.deepOrange,
    colorScheme: const ColorScheme.light(
      primary: Colors.deepOrange,
      secondary: Colors.orangeAccent,
    ),
    fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.black87,
    ),
  );
}
