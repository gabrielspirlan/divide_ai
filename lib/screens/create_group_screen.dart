import 'package:flutter/material.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/components/ui/card_input.dart';
import 'package:divide_ai/components/ui/button.dart';
import 'package:divide_ai/components/group/select_members_group.dart';
import 'package:divide_ai/components/group/color_selector.dart';
import 'package:divide_ai/models/data/group.dart';
import 'package:divide_ai/models/data/user.dart';
import 'package:divide_ai/models/enums/color_selector_variant.dart';
import 'package:divide_ai/services/analytics_service.dart';
import 'package:divide_ai/screens/home_group_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Set<int> _selectedIndexes = {0};
  Color? _selectedColor;

  final User currentUser = users.first;

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
    AnalyticsService.trackPageView('create_group_screen');
    AnalyticsService.trackPageLoading('create_group_screen', loadTime);
  }

  Future<void> _createGroup() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _selectedColor == null) return;

    final selectedUsers = _selectedIndexes.map((i) => users[i]).toList();

    final newGroup = Group(
      name,
      description: _descriptionController.text.trim(),
      participantIds: selectedUsers.map((u) => u.id).toList(),
      value: 0.0,
      backgroundIconColor: _selectedColor!,
    );

    groups.add(newGroup);

    AnalyticsService.trackEvent(
      elementId: 'criar_grupo_button',
      eventType: 'CLICK',
      page: 'create_group_screen',
    );

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeGroupScreen(),
      ),
      (route) => false,
    );
  }

  void _onSelectionChanged(Set<int> indexes) {
    setState(() {
      _selectedIndexes
        ..clear()
        ..addAll(indexes);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        "Novo Grupo",
        description: "Crie um grupo para dividir despesas",
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
            Text(
              "Membros do grupo",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            SelectMembersGroup(
              participants: users,
              mainUser: currentUser,
              canDeselectMainUser: false,
              onSelectionChanged: _onSelectionChanged,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Button(
                text: "Criar Grupo",
                icon: Icons.group_add_outlined,
                onPressed: _createGroup,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
