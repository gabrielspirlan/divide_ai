import 'package:flutter/material.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/components/ui/card_input.dart';
import 'package:divide_ai/components/ui/button.dart';
import 'package:divide_ai/components/group/select_members_group.dart';
import 'package:divide_ai/components/group/color_selector.dart';
import 'package:divide_ai/models/enums/color_selector_variant.dart';
import 'package:divide_ai/services/analytics_service.dart';
import 'package:divide_ai/screens/home_group_screen.dart';
import 'package:divide_ai/models/data/group_api_model.dart';
import 'package:divide_ai/models/data/user.dart';
import 'package:divide_ai/services/group_service.dart';
import 'package:divide_ai/services/user_service.dart';
import 'package:divide_ai/services/session_service.dart';

class CreateGroupScreen extends StatefulWidget {
  final String? groupId; // Para edição

  const CreateGroupScreen({super.key, this.groupId});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<String> _selectedUserIds = [];
  Color? _selectedColor;

  final GroupService _groupService = GroupService();

  late final int _pageLoadStartTime;
  bool _isEditing = false;
  bool _isLoading = false;
  bool _isLoadingUsers = true;
  GroupApiModel? _currentGroup;
  List<User> _allUsers = [];
  Set<int> _initialSelectedIndexes = {};

  @override
  void initState() {
    super.initState();
    _pageLoadStartTime = DateTime.now().millisecondsSinceEpoch;
    _isEditing = widget.groupId != null;

    if (_isEditing) {
      _loadGroupData();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackPageLoad();
    });
  }

  Future<void> _loadGroupData() async {
    if (widget.groupId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Carrega os dados do grupo
      final group = await _groupService.getGroupById(widget.groupId!);

      // Carrega todos os usuários para mapear os participantes
      final userService = UserService();
      final allUsers = await userService.getAllUsersPaginated();

      // Busca o ID do usuário logado
      final currentUserId = await SessionService.getUserId();

      // Organiza os usuários (usuário logado primeiro)
      final List<User> organized = [];
      final currentUser = allUsers.firstWhere(
        (user) => user.id == currentUserId,
        orElse: () => allUsers.first,
      );
      organized.add(currentUser);
      for (final user in allUsers) {
        if (user.id != currentUser.id) {
          organized.add(user);
        }
      }

      // Mapeia os participantes do grupo para índices
      Set<int> initialIndexes = {};
      for (int i = 0; i < organized.length; i++) {
        if (group.participants.contains(organized[i].id)) {
          initialIndexes.add(i);
        }
      }

      if (mounted) {
        _nameController.text = group.name;
        _descriptionController.text = group.description;
        _selectedUserIds = group.participants;

        // Converte a cor hex para Color
        final hexColor = group.backgroundIconColor.replaceAll('#', '');
        _selectedColor = Color(int.parse('FF$hexColor', radix: 16));

        setState(() {
          _currentGroup = group;
          _allUsers = organized;
          _initialSelectedIndexes = initialIndexes;
          _isLoading = false;
          _isLoadingUsers = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar grupo: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingUsers = false;
        });
      }
    }
  }

  void _trackPageLoad() {
    final loadTime = DateTime.now().millisecondsSinceEpoch - _pageLoadStartTime;
    AnalyticsService.trackPageView('create_group_screen');
    AnalyticsService.trackPageLoading('create_group_screen', loadTime);
  }

  Future<void> _saveGroup() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _selectedColor == null) return;

    // Converte a cor para hex
    final colorHex = '#${_selectedColor!.toARGB32().toRadixString(16).substring(2)}';

    // 🧩 Modelo compatível com a API
    final groupData = GroupApiModel(
      id: _isEditing ? widget.groupId : null,
      name: name,
      description: _descriptionController.text.trim(),
      participants: _selectedUserIds,
      backgroundIconColor: colorHex,
    );

    try {
      if (_isEditing && widget.groupId != null) {
        await _groupService.updateGroup(widget.groupId!, groupData);
      } else {
        await _groupService.createGroup(groupData);
      }
    } catch (e) {
      debugPrint("Erro ao salvar grupo: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? "Erro ao atualizar grupo" : "Erro ao criar grupo")),
      );
      return;
    }

    AnalyticsService.trackEvent(
      elementId: _isEditing ? 'editar_grupo_button' : 'criar_grupo_button',
      eventType: 'CLICK',
      page: 'create_group_screen',
    );

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    if (_isEditing) {
      Navigator.of(context).pop(true); // Retorna true para indicar que houve alteração
    } else {
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeGroupScreen(),
        ),
        (route) => false,
      );
    }
  }

  void _onSelectionChanged(Set<int> indexes, List<String> userIds) {
    setState(() {
      _selectedUserIds = userIds;
    });
  }

  Future<void> _deleteGroup() async {
    // Mostra dialog de confirmação
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text(
          'Tem certeza que deseja excluir este grupo? '
          'Todas as despesas associadas serão perdidas. '
          'Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true || widget.groupId == null) return;

    try {
      await _groupService.deleteGroup(widget.groupId!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Grupo excluído com sucesso!')),
        );

        // Retorna para a tela anterior e força reload
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      debugPrint('Erro ao excluir grupo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao excluir grupo. Tente novamente.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTitle = _isEditing ? "Editar Grupo" : "Novo Grupo";
    final appBarDescription = _isEditing
        ? "Atualize as informações do grupo"
        : "Crie um grupo para dividir despesas";
    final buttonText = _isEditing ? "Salvar Alterações" : "Criar Grupo";

    if (_isLoading) {
      return Scaffold(
        appBar: CustomAppBar(appBarTitle, description: appBarDescription),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        appBarTitle,
        description: appBarDescription,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardInput(
              "Nome do grupo",
              controller: _nameController,
              hint: "Ex: Restaurante Japonês, Viagem Praia...",
              icon: Icons.description_outlined,
            ),
            const SizedBox(height: 16),
            CardInput(
              "Descrição (opcional)",
              controller: _descriptionController,
              hint: "Descreva o propósito do grupo...",
              icon: Icons.description_outlined,
            ),
            const SizedBox(height: 16),
            ColorSelector(
              variant: ColorSelectorVariant.azul,
              onColorSelected: (color) {
                _selectedColor = color;
              },
            ),
            const SizedBox(height: 16),
            SelectMembersGroup(
              onSelectionChanged: _onSelectionChanged,
              initialSelectedIndexes: _isEditing ? _initialSelectedIndexes : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Button(
                text: buttonText,
                icon: _isEditing ? Icons.save : Icons.group_add_outlined,
                onPressed: _saveGroup,
              ),
            ),
            // Botão de excluir (apenas no modo de edição)
            if (_isEditing) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _deleteGroup,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text(
                    'Excluir Grupo',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}