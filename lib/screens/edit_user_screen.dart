import 'package:divide_ai/components/ui/button.dart';
import 'package:divide_ai/components/ui/input.dart'; 
import 'package:divide_ai/models/data/user.dart';
import 'package:divide_ai/models/data/user_request.dart';
import 'package:divide_ai/services/user_service.dart';
import 'package:divide_ai/services/session_service.dart'; // Para obter o ID
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); // Usado para enviar a senha atualizada
  
  final UserService _userService = UserService();
  
  String? _currentUserId;
  bool _isLoading = true; // Para carregar os dados iniciais
  bool _isSaving = false; // Para o estado do botão

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // NOVO MÉTODO: Carrega os dados do usuário logado
  Future<void> _loadUserData() async {
    try {
      final userId = await SessionService.getUserId();
      if (userId == null) throw Exception("Usuário não logado.");

      _currentUserId = userId;
      
      // Busca os dados do usuário (nome e email)
      final User user = await _userService.getUserById(userId);
      
      if (mounted) {
        _nameController.text = user.name;
        _emailController.text = user.email;
        // Senha não é pré-preenchida por segurança.
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados do usuário: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showMessage('Falha ao carregar dados. Tente novamente.');
      }
    }
  }

  // MÉTODO ADAPTADO: Atualiza o usuário (PUT)
  void _updateUser() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      _showMessage('Nome e email são obrigatórios.');
      return;
    }

    // Garantir que o ID esteja disponível
    if (_currentUserId == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Só envia a senha se ela não estiver vazia
      final userRequest = UserRequest(
        name: name,
        email: email,
        password: password.isEmpty ? null : password,
      );

      // CHAMA O PUT /users/{id}
      await _userService.updateUser(_currentUserId!, userRequest);

      if (mounted) {
        _showMessage('Informações atualizadas com sucesso!');
        Navigator.of(context).pop(true); // Retorna à tela de configurações
      }
    } catch (e) {
      debugPrint('Erro na atualização: $e');
      _showMessage('Falha na atualização. Verifique os dados.');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
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
        title: const Text('Editar Perfil'), // Título alterado
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Mostra loading ao carregar dados
          : SafeArea(
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
                                // 1. CAMPO NOME COMPLETO (Pré-preenchido)
                                Input(
                                  'Nome completo',
                                  hint: 'Seu nome',
                                  icon: HugeIcons.strokeRoundedUser02,
                                  controller: _nameController,
                                  keyboardType: TextInputType.name,
                                  size: InputSize.large,
                                ),

                                const SizedBox(height: 16),

                                // 2. CAMPO EMAIL (Pré-preenchido)
                                Input(
                                  'Email',
                                  hint: 'seu@email.com',
                                  icon: HugeIcons.strokeRoundedMail01,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  size: InputSize.large,
                                ),

                                const SizedBox(height: 16),

                                // 3. CAMPO SENHA (Deixado para alteração)
                                Input(
                                  'Nova Senha',
                                  hint: '********',
                                  icon: HugeIcons.strokeRoundedSquareLockPassword,
                                  controller: _passwordController,
                                  obscureText: true,
                                  size: InputSize.large,
                                ),

                                const SizedBox(height: 30),

                                // Botão Atualizar
                                _isSaving
                                    ? const Center(child: CircularProgressIndicator())
                                    : Button(
                                        text: "Atualizar", // Texto alterado
                                        onPressed: _updateUser,
                                        size: ButtonSize.large,
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