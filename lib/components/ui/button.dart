import 'package:flutter/material.dart';

enum ButtonSize { small, medium, large }

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final ButtonSize size;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.size = ButtonSize.medium,
  });

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _getHeight(),
      width: double.infinity, // 🔹 botão ocupa largura total do container
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24), // 🔹 espaçamento fixo
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 🔹 garante centralização
          mainAxisSize: MainAxisSize.max,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: _getFontSize() + 2,
                color: Colors.white,
              ),
              const SizedBox(width: 12), // 🔹 aumentei o espaçamento ícone-texto
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
