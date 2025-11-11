import 'package:divide_ai/components/ui/button.dart';
import 'package:divide_ai/components/ui/input.dart';
import 'package:divide_ai/screens/home_group_screen.dart';
import 'package:divide_ai/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _performLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Preencha todos os campos.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.login(email, password);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeGroupScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      _showMessage(
        e.toString().contains('Credenciais inválidas')
            ? 'Email ou senha incorretos.'
            : 'Erro ao conectar. Tente novamente.',
      );
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBorderColor = const Color(0xFF3A3A3A);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Entrar'),
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
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
                          // Campo de Email usando o componente Input
                          Input(
                            'Email',
                            hint: 'seu@email.com',
                            icon: FontAwesomeIcons.solidEnvelope,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            size: InputSize.large,
                          ),

                          const SizedBox(height: 18),

                          // Campo de Senha usando o componente Input
                          Input(
                            'Senha',
                            hint: '********',
                            icon: FontAwesomeIcons.lock,
                            controller: _passwordController,
                            obscureText: true,
                            size: InputSize.large,
                          ),

                          const SizedBox(height: 24),

                          // Botão Entrar
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Button(
                                  text: "Entrar",
                                  onPressed: _performLogin,
                                  size: ButtonSize.large,
                                ),

                          const SizedBox(height: 14),

                          // Link Cadastre-se
                          Center(
                            child: TextButton(
                              onPressed: () {
                                _showMessage("Funcionalidade de Cadastro pendente.");
                              },
                              child: Text(
                                "Não tem conta? Cadastre-se",
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
