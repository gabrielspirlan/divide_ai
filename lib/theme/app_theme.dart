import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    textTheme: GoogleFonts.robotoTextTheme(Typography.blackCupertino),
    scaffoldBackgroundColor: Color(0x00ffffff),
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
    focusColor: Color(0xFF6a6a6a),
    textTheme: GoogleFonts.robotoTextTheme(Typography.whiteCupertino),
    scaffoldBackgroundColor: Color(0xFF1a1a1a),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF252525),
      titleTextStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 26),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.white)),
    ),

    colorScheme: ColorScheme.fromSeed(
      primary: const Color(0xFF1447e6), // Cor primária (Logo, botões)
      onPrimary: const Color(0xFF273752),
      primaryContainer: const Color(
        0xFF1b2431,
      ), // Cor de Hover ou ativação da primária
      inversePrimary: Color(0xFF93c5fd), // Cor de texto na primária
      onPrimaryFixed: Color(0xFF51A2FF), // Cor de texto na primária
      secondary: const Color(0xFF10b981), // Cor secundária
      secondaryContainer: const Color(0xFF172b1f),
      onSecondary: Color(0xFF1e462e),
      onSecondaryFixed: Color(0xFF07da70),
      seedColor: Color(0x001447e6),
      onBackground: Color(0xFF252525),
      surfaceContainer: Color(0xFF313131),
      brightness: Brightness.dark,
    ),
  );
}
