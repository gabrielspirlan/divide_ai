import 'package:divide_ai/screens/transactions_group_screen.dart';
import 'package:divide_ai/screens/home_group_screen.dart';
import 'package:divide_ai/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Divide Aí',
      theme: AppTheme.darkTheme,
      home: const HomeGroupScreen(),
    );
  }
}
