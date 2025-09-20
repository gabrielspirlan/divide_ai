import 'package:divide_ai/components/ui/input.dart';
import 'package:flutter/material.dart';

class CardInput extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final InputSize size;

  const CardInput(
    this.label, {
    super.key,
    this.hint,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.controller,
    this.size = InputSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onBackground,

      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Input(
          label,
          hint: hint,
          icon: icon,
          keyboardType: keyboardType,
          obscureText: obscureText,
          controller: controller,
          size: size,
        ),
      ),
    );
  }
}
