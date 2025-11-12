import 'package:flutter/material.dart';
import 'package:divide_ai/services/analytics_service.dart';

enum ButtonSize { small, medium, large }

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final ButtonSize size;
  final bool isLink; // NOVO: Controla se o botão deve ser renderizado como link

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.size = ButtonSize.medium,
    this.isLink = false, // NOVO: Default é falso
  });

  void _trackButtonClick(BuildContext context) {
    final route = ModalRoute.of(context);
    final pageName = route?.settings.name ?? 'unknown_page';
    AnalyticsService.trackButtonClick(text, pageName);
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return 40;
      case ButtonSize.medium:
        return 50;
      case ButtonSize.large:
        return 60;
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 18, vertical: 2);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Se for um link, usamos TextButton
    if (isLink) {
      final theme = Theme.of(context);
      
      // TextButton não usa o SizedBox height e width, ele se ajusta ao texto
      return TextButton(
        onPressed: () {
          _trackButtonClick(context);
          onPressed();
        },
        style: TextButton.styleFrom(
          // Fundo transparente
          padding: EdgeInsets.zero, 
          // Retira o padding padrão do TextButton
          minimumSize: Size.zero, 
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: theme.colorScheme.primary, // Cor primária do tema para links
            fontSize: _getFontSize(),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    // Comportamento padrão para ElevatedButton
    return SizedBox(
      height: _getHeight(),
      width: size == ButtonSize.small ? null : double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          overlayColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: size == ButtonSize.small
                ? BorderRadius.circular(200)
                : BorderRadius.circular(12),
          ),
          padding: _getPadding(),
          minimumSize: size == ButtonSize.small ? Size.zero : null,
          tapTargetSize: size == ButtonSize.small
              ? MaterialTapTargetSize.shrinkWrap
              : null,
        ),
        onPressed: () {
          _trackButtonClick(context);
          onPressed();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (icon != null) ...[
              Icon(icon, size: _getFontSize() + 2, color: Colors.white),
              const SizedBox(width: 10), // Adiciona espaçamento entre ícone e texto
            ],
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: _getFontSize(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}