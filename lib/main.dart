import 'package:divide_ai/screens/home_group_screen.dart';
import 'package:divide_ai/screens/login_screen.dart'; 
import 'package:divide_ai/services/session_service.dart'; 
import 'package:divide_ai/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. CARREGA O ARQUIVO .ENV
  await dotenv.load(fileName: ".env"); 
  
  await initializeDateFormatting('pt_BR', null);
  
  // VERIFICAÇÃO INICIAL DE SESSÃO
  final isLoggedIn = await SessionService.isUserLoggedIn(); 
  
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Divide Aí',
      theme: AppTheme.darkTheme,
      // Se logado, vai para Home, se não, vai para Login
      home: isLoggedIn ? const HomeGroupScreen() : const LoginScreen(), 
    );
  }
}