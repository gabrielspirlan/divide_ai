import 'package:flutter/material.dart';
import 'package:divide_ai/components/ui/select_member.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:divide_ai/models/data/user.dart';

class SelectMembersTransactions extends StatefulWidget {
  final List<User> participants;
  final Set<int>? initialSelectedIndexes;
  final Function(Set<int>)? onSelectionChanged;

  const SelectMembersTransactions({
    Key? key,
    required this.participants,
    this.initialSelectedIndexes,
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<SelectMembersTransactions> createState() => _SelectMembersTransactionsState();
}

class _SelectMembersTransactionsState extends State<SelectMembersTransactions> {
  late Set<int> selectedIndexes;

  @override
  void initState() {
    super.initState();

    // Inicializa com os índices fornecidos ou vazio
    selectedIndexes = widget.initialSelectedIndexes ?? {};

    // Notificar a seleção inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelectionChanged?.call(selectedIndexes);
    });
  }

  void _onSelectionChanged(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });

    widget.onSelectionChanged?.call(selectedIndexes);
  }

  List<User> getSelectedUsers() {
    return selectedIndexes.map((index) => widget.participants[index]).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
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
                "Participantes da Transação",
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
            children: List.generate(widget.participants.length, (index) {
              final user = widget.participants[index];
              return SelectMember(
                name: user.name,
                email: user.email,
                isYou: false, // Nenhum usuário é marcado como "Você" neste componente
                isSelected: selectedIndexes.contains(index),
                onTap: () => _onSelectionChanged(index),
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

