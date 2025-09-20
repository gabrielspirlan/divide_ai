import 'package:flutter/material.dart';
import 'package:divide_ai/components/ui/select_member.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:divide_ai/models/data/user.dart';

class SelectMembersGroup extends StatefulWidget {
  final List<User> participants;
  final User mainUser;
  final Set<int>? initialSelectedIndexes;
  final Function(Set<int>)? onSelectionChanged;
  final bool canDeselectMainUser;

  const SelectMembersGroup({
    Key? key,
    required this.participants,
    required this.mainUser,
    this.initialSelectedIndexes,
    this.onSelectionChanged,
    this.canDeselectMainUser = false,
  }) : super(key: key);

  @override
  State<SelectMembersGroup> createState() => _SelectMembersGroupState();
}

class _SelectMembersGroupState extends State<SelectMembersGroup> {
  late Set<int> selectedIndexes;
  late List<User> orderedParticipants;

  @override
  void initState() {
    super.initState();

    orderedParticipants = _organizeParticipants();

    selectedIndexes = widget.initialSelectedIndexes ?? {0};

    if (!widget.canDeselectMainUser) {
      selectedIndexes.add(0);
    }

    // Notificar a seleção inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelectionChanged?.call(selectedIndexes);
    });
  }

  List<User> _organizeParticipants() {
    final List<User> organized = [];

    organized.add(widget.mainUser);

    for (final participant in widget.participants) {
      if (participant.id != widget.mainUser.id) {
        organized.add(participant);
      }
    }

    return organized;
  }

  void _onSelectionChanged(int index) {
    setState(() {
      if (index == 0 && !widget.canDeselectMainUser) {
        return;
      }

      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });

    widget.onSelectionChanged?.call(selectedIndexes);
  }

  List<User> getSelectedUsers() {
    return selectedIndexes.map((index) => orderedParticipants[index]).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.onBackground,
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
                "Participantes",
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
            children: List.generate(orderedParticipants.length, (index) {
              final user = orderedParticipants[index];
              return SelectMember(
                name: user.name,
                email: user.email,
                isYou: index == 0, // O primeiro sempre é o usuário principal
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
