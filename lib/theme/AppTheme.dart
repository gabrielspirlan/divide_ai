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
    textTheme: GoogleFonts.robotoTextTheme(Typography.whiteCupertino),
    scaffoldBackgroundColor: Color(0x0a0a0a),
    appBarTheme: AppBarTheme(backgroundColor: Color(0x1447e6)),
    colorScheme: ColorScheme.fromSeed(
      primary: Color(0x1447e6),
      seedColor: Color(0x1447e6),
      brightness: Brightness.dark,
    ),
  );
}
