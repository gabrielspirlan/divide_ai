import 'package:divide_ai/components/ui/button.dart';
import 'package:divide_ai/components/ui/input.dart'; // IMPORT DO INPUT SIMPLES
import 'package:divide_ai/screens/home_group_screen.dart';
import 'package:divide_ai/screens/login_screen.dart';
import 'package:divide_ai/services/user_service.dart';
import 'package:divide_ai/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:divide_ai/models/data/user_request.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _performRegistration() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage('Preencha todos os campos.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userRequest = UserRequest(
        name: name,
        email: email,
        password: password,
      );

      // 1. Cadastra o usuário
      await _userService.registerUser(userRequest);
      _showMessage('Cadastro realizado com sucesso!');

      // 2. Faz login automático
      await _authService.login(email, password);

      if (mounted) {
        // Navega para a Home e remove todas as rotas
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeGroupScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Erro no cadastro: $e');
      _showMessage('Falha no cadastro. Verifique os dados ou tente mais tarde.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _navigateToLogin() {
    // Substitui a rota para ir para o Login
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBorderColor = const Color(0xFF3A3A3A); // Cor usada no Card

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Card(
                    color: theme.colorScheme.surface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: cardBorderColor.withOpacity(0.25), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. CAMPO NOME COMPLETO: USANDO INPUT SIMPLES
                          Input(
                            'Nome completo',
                            hint: 'Seu nome',
                            icon: HugeIcons.strokeRoundedUser02,
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            size: InputSize.large,
                          ),

                          const SizedBox(height: 16),

                          // 2. CAMPO EMAIL: USANDO INPUT SIMPLES
                          Input(
                            'Email',
                            hint: 'seu@email.com',
                            icon: HugeIcons.strokeRoundedMail01,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            size: InputSize.large,
                          ),

                          const SizedBox(height: 16),

                          // 3. CAMPO SENHA: USANDO INPUT SIMPLES
                          Input(
                            'Senha',
                            hint: '********',
                            icon: HugeIcons.strokeRoundedSquareLockPassword,
                            controller: _passwordController,
                            obscureText: true,
                            size: InputSize.large,
                          ),

                          const SizedBox(height: 30),

                          // Botão Criar Conta
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Button(
                                  text: "Criar Conta",
                                  onPressed: _performRegistration,
                                  size: ButtonSize.large,
                                ),

                          const SizedBox(height: 14),

                          // Link Entrar
                          Center(
                            child: TextButton(
                              onPressed: _navigateToLogin,
                              child: Text(
                                "Já tem conta? Entre",
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}