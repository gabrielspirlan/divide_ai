import 'package:flutter/material.dart';
import 'package:divide_ai/services/session_service.dart';
import 'package:divide_ai/screens/login_screen.dart';
import 'package:divide_ai/screens/home_group_screen.dart';

/// Tela de Splash que verifica se o usuário já está logado
/// Se estiver logado, redireciona para HomeGroupScreen
/// Se não estiver logado, redireciona para LoginScreen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  /// Verifica se existe uma sessão ativa
  Future<void> _checkSession() async {
    // Aguarda um pequeno delay para exibir a splash screen
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    // Verifica se o usuário está logado
    final isLoggedIn = await SessionService.isUserLoggedIn();

    if (!mounted) return;

    // Navega para a tela apropriada
    if (isLoggedIn) {
      // Usuário já está logado, vai direto para a home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeGroupScreen()),
      );
    } else {
      // Usuário não está logado, vai para a tela de login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo ou ícone do app
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            // Nome do app
            Text(
              'Divide Aí',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            // Slogan
            Text(
              'Divida gastos com facilidade',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

