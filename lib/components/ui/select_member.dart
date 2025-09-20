import 'package:flutter/material.dart';

class SelectMember extends StatelessWidget {
  final String name;
  final String email;
  final bool isSelected;
  final bool isYou;
  final VoidCallback onTap;

  static const double checkboxColumnWidth = 40.0;

  const SelectMember({
    Key? key,
    required this.name,
    required this.email,
    required this.isSelected,
    required this.onTap,
    this.isYou = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: SelectMember.checkboxColumnWidth,
              child: Center(
                child: Checkbox(
                  value: isSelected,
                  onChanged: (_) => onTap(),
                  activeColor: theme.colorScheme.onPrimaryFixed, 
                  checkColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? theme.colorScheme.onPrimaryFixed
                              : theme.colorScheme.onSurface, 
                          fontSize: 16,
                        ),
                      ),
                      if (isYou) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onPrimaryFixed.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.onPrimaryFixed,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            "Você",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimaryFixed,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
