import 'package:flutter/material.dart';
import 'package:divide_ai/models/data/user.dart';
import 'package:divide_ai/components/users/user_card.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/screens/analytics_screen.dart';
import 'package:divide_ai/screens/edit_user_screen.dart'; 
import 'package:divide_ai/screens/login_screen.dart';
import 'package:divide_ai/services/analytics_service.dart';
import 'package:divide_ai/services/session_service.dart';
import 'package:divide_ai/services/user_service.dart';
// REMOVIDO: import 'package:divide_ai/services/session_service.dart'; (duplicado)

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final int _pageLoadStartTime;
  
  // NOVO ESTADO: Usuário logado
  User? _loggedUser;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _pageLoadStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadLoggedUser(); // Inicia o carregamento do usuário
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackPageLoad();
    });
  }

  // NOVO MÉTODO: Carrega o usuário logado via API
  Future<void> _loadLoggedUser() async {
    try {
      final user = await UserService().getLoggedUser();
      if (mounted) {
        setState(() {
          _loggedUser = user;
          _isLoadingUser = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar usuário logado: $e');
      if (mounted) {
        setState(() {
          _isLoadingUser = false;
        });
      }
      // Se falhar, pode ser um token inválido, forçar logout
      if (e.toString().contains('Nenhum usuário logado')) {
        await SessionService.clearSession();
        if (mounted) _navigateToLoginScreen();
      }
    }
  }

  void _trackPageLoad() {
    final loadTime = DateTime.now().millisecondsSinceEpoch - _pageLoadStartTime;
    AnalyticsService.trackPageView('settings_screen');
    AnalyticsService.trackPageLoading('settings_screen', loadTime);
  }
  
  // CORRIGIDO: Retorna Future<void> e é assíncrono (async)
  Future<void> _navigateToLoginScreen() async {
     Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // NOVO MÉTODO: Navegação para a edição
  void _navigateToEditUser() async {
    // Rastreamento opcional (se UserCard não rastrear o clique)
    AnalyticsService.trackEvent(
      elementId: 'user_card_profile',
      eventType: 'CLICK',
      page: 'settings_screen',
    );
    
    // Navegação para a tela de edição
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditUserScreen(), 
      ),
    );
    
    // Se a edição foi bem-sucedida, recarrega os dados para atualizar o UserCard
    if (result == true && mounted) {
      _loadLoggedUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBackground = theme.colorScheme.onBackground;
    final iconColor = theme.colorScheme.onSurfaceVariant;

    // Se estiver carregando ou o usuário não for encontrado
    if (_isLoadingUser || _loggedUser == null) {
      return Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: CustomAppBar("Perfil", description: "Gerencie sua conta"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    // Usa o usuário carregado
    final user = _loggedUser!; 

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        "Perfil",
        description: "Gerencie sua conta",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // USER CARD: Agora usa o usuário carregado e navega para edição
            UserCard(
              user,
              onTap: _navigateToEditUser, 
            ),
            const SizedBox(height: 20),

            // CONFIGURAÇÕES
            Text(
              "Configurações",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              color: cardBackground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _SettingsListTile(
                    icon: Icons.person_outline,
                    title: "Informações pessoais",
                    subtitle: "Nome, email e telefone",
                    iconColor: iconColor,
                    elementId: 'informacoes_pessoais_tile',
                    pageName: 'settings_screen',
                    // Redireciona o tile de Informações Pessoais para a tela de edição
                    onTap: _navigateToEditUser, 
                  ),
                  Divider(color: theme.colorScheme.onSurface.withOpacity(0.2), height: 1),
                  _SettingsListTile(
                    icon: Icons.notifications_outlined,
                    title: "Notificações",
                    subtitle: "Alertas e lembretes",
                    iconColor: iconColor,
                    elementId: 'notificacoes_tile',
                    pageName: 'settings_screen',
                    onTap: () {},
                  ),
                  Divider(color: theme.colorScheme.onSurface.withOpacity(0.2), height: 1),
                  _SettingsListTile(
                    icon: Icons.lock_outline,
                    title: "Privacidade e segurança",
                    subtitle: "Senha e configurações de privacidade",
                    iconColor: iconColor,
                    elementId: 'privacidade_e_seguranca_tile',
                    pageName: 'settings_screen',
                    onTap: () {},
                  ),
                  Divider(color: theme.colorScheme.onSurface.withOpacity(0.2), height: 1),
                  _SettingsListTile(
                    icon: Icons.bar_chart_outlined,
                    title: "Analytics Dashboard",
                    subtitle: "Métricas de uso e performance",
                    iconColor: iconColor,
                    elementId: 'analytics_dashboard_tile',
                    pageName: 'settings_screen',
                    onTap: () async {
                      await Future.delayed(const Duration(milliseconds: 300));
                      if (context.mounted) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AnalyticsScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // NOVA SEÇÃO: CONTA / LOGOUT 
            Text(
              "Conta",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              color: cardBackground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                   _SettingsListTile(
                    icon: Icons.logout,
                    title: "Sair da Conta",
                    subtitle: "Encerra a sessão atual",
                    iconColor: Colors.red,
                    elementId: 'logout_tile',
                    pageName: 'settings_screen',
                    onTap: () async {
                      await SessionService.clearSession(); 
                      if (context.mounted) {
                        // Chama o método que navega após a limpeza
                        _navigateToLoginScreen(); 
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // SUPORTE
            Text(
              "Suporte",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              color: cardBackground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: _SettingsListTile(
                icon: Icons.mail_outline,
                title: "Contato",
                subtitle: "Entre em contato conosco",
                iconColor: iconColor,
                elementId: 'contato_tile',
                pageName: 'settings_screen',
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;
  final String elementId;
  final String pageName;

  const _SettingsListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
    required this.elementId,
    required this.pageName,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      onTap: () {
        AnalyticsService.trackEvent(
          elementId: elementId,
          eventType: 'CLICK',
          page: pageName,
        );
        onTap();
      },
    );
  }
}