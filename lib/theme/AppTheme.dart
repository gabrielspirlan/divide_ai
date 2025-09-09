import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    textTheme: GoogleFonts.robotoTextTheme(Typography.blackCupertino),
    scaffoldBackgroundColor: Color(0xffffff),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepPurple,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: Color(0xFF155DFC),
    focusColor: Color(0xFF6a6a6a),
    textTheme: GoogleFonts.robotoTextTheme(Typography.whiteCupertino),
    scaffoldBackgroundColor: Color(0xFF1a1a1a),
    appBarTheme: AppBarTheme(backgroundColor: Color(0xFF252525)),
    colorScheme: ColorScheme.fromSeed(
      primary: Color(0xFF155DFC),
      background: Color(0xFF252525),
      onBackground: Color(0xFF2a2a2a),
      seedColor: Color(0x1447e6),
      brightness: Brightness.dark,
    ),
  );
}
