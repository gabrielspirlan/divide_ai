import 'package:flutter/material.dart';
import 'package:divide_ai/models/data/user.dart';
import 'package:divide_ai/components/users/user_card.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/screens/analytics_screen.dart';
import 'package:divide_ai/services/analytics_service.dart';
import 'package:divide_ai/services/session_service.dart';
import 'package:divide_ai/screens/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final int _pageLoadStartTime;

  @override
  void initState() {
    super.initState();
    _pageLoadStartTime = DateTime.now().millisecondsSinceEpoch;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackPageLoad();
    });
  }

  void _trackPageLoad() {
    final loadTime = DateTime.now().millisecondsSinceEpoch - _pageLoadStartTime;
    AnalyticsService.trackPageView('settings_screen');
    AnalyticsService.trackPageLoading('settings_screen', loadTime);
  }

  @override
  Widget build(BuildContext context) {
    final user = users.first;
    final theme = Theme.of(context);
    final cardBackground = theme.colorScheme.onBackground;
    final iconColor = theme.colorScheme.onSurfaceVariant;

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
            UserCard(
              user,
              onTap: () {},
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
                    onTap: () {},
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
                      await SessionService.clearSession(); // limpa sessão
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false, // remove todas as telas anteriores
                        );
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
