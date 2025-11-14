import 'package:flutter/material.dart';
import 'package:divide_ai/components/ui/select_member.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:divide_ai/models/data/user.dart';
import 'package:divide_ai/services/user_service.dart';
import 'package:divide_ai/services/session_service.dart';

class SelectMembersGroup extends StatefulWidget {
  final Set<int>? initialSelectedIndexes;
  final Function(Set<int>, List<String>)? onSelectionChanged;

  const SelectMembersGroup({
    Key? key,
    this.initialSelectedIndexes,
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<SelectMembersGroup> createState() => _SelectMembersGroupState();
}

class _SelectMembersGroupState extends State<SelectMembersGroup> {
  final UserService _userService = UserService();

  late Set<int> selectedIndexes;
  List<User> orderedParticipants = [];
  bool isLoading = true;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      // Busca o ID do usuário logado
      currentUserId = await SessionService.getUserId();

      // Busca todos os usuários da API
      final allUsers = await _userService.getAllUsersPaginated();

      if (mounted) {
        setState(() {
          orderedParticipants = _organizeParticipants(allUsers);

          // Inicializa com o usuário logado sempre selecionado (índice 0)
          selectedIndexes = widget.initialSelectedIndexes ?? {0};
          selectedIndexes.add(
            0,
          ); // Garante que o usuário logado está selecionado

          isLoading = false;
        });

        // Notificar a seleção inicial
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final selectedUserIds = selectedIndexes
              .map((index) => orderedParticipants[index].id)
              .toList();
          widget.onSelectionChanged?.call(selectedIndexes, selectedUserIds);
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar usuários: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<User> _organizeParticipants(List<User> users) {
    final List<User> organized = [];

    // Encontra o usuário logado e coloca em primeiro
    final currentUser = users.firstWhere(
      (user) => user.id == currentUserId,
      orElse: () => users.first,
    );
    organized.add(currentUser);

    // Adiciona os demais usuários
    for (final user in users) {
      if (user.id != currentUser.id) {
        organized.add(user);
      }
    }

    return organized;
  }

  void _onSelectionChanged(int index) {
    setState(() {
      // O usuário logado (índice 0) não pode ser desmarcado
      if (index == 0) {
        return;
      }

      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });

    final selectedUserIds = selectedIndexes
        .map((index) => orderedParticipants[index].id)
        .toList();
    widget.onSelectionChanged?.call(selectedIndexes, selectedUserIds);
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
        color: Theme.of(context).colorScheme.surfaceContainer,
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

          // Loading ou Lista de usuários
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (orderedParticipants.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Nenhum usuário encontrado",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryFixed,
                  ),
                ),
              ),
            )
          else
            Column(
              children: List.generate(orderedParticipants.length, (index) {
                final user = orderedParticipants[index];
                return SelectMember(
                  name: user.name,
                  email: user.email,
                  isYou: index == 0, // O primeiro sempre é o usuário logado
                  isSelected: selectedIndexes.contains(index),
                  onTap: () => _onSelectionChanged(index),
                );
              }),
            ),

          const SizedBox(height: 14),

          // Rodapé
          if (!isLoading)
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
