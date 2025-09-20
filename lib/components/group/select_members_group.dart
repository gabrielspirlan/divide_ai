import 'package:flutter/material.dart';
import 'package:divide_ai/components/ui/select_member.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:divide_ai/models/data/user.dart';

class SelectMembersGroup extends StatefulWidget {
  const SelectMembersGroup({Key? key}) : super(key: key);

  @override
  State<SelectMembersGroup> createState() => _SelectMembersGroupState();
}

class _SelectMembersGroupState extends State<SelectMembersGroup> {
  final Set<int> selectedIndexes = {0};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.focusColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cabeçalho
          Row(
            children: [
              SizedBox(
                width: SelectMember.checkboxColumnWidth,
                child: Center(
                  child: Icon(
                    HugeIcons.strokeRoundedUserAdd02,
                    color: theme.colorScheme.onPrimaryFixed,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Membros do grupo",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  fontSize: 17,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Lista de usuários
          Column(
            children: List.generate(users.length, (index) {
              final user = users[index];
              return SelectMember(
                name: user.name,
                email: user.email,
                isYou: index == 0, 
                isSelected: selectedIndexes.contains(index),
                onTap: () {
                  setState(() {
                    if (selectedIndexes.contains(index)) {
                      selectedIndexes.remove(index);
                    } else {
                      selectedIndexes.add(index);
                    }
                  });
                },
              );
            }),
          ),

          const SizedBox(height: 14),

          // Rodapé
          Row(
            children: [
              SizedBox(width: SelectMember.checkboxColumnWidth),
              const SizedBox(width: 8),
              Text(
                "${selectedIndexes.length} membro(s) selecionado(s)",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryFixed,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
