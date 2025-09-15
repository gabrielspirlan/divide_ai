import 'package:divide_ai/components/ui/item_menu.dart'; 
import 'package:flutter/material.dart';
import 'package:divide_ai/theme/AppTheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      home: const TransactionTestPage(),
    );
  }
}

class TransactionTestPage extends StatelessWidget {
  const TransactionTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menus Teste")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Aqui entra apenas o menu que você quer
            ItemMenu(
              icon: Icons.person_outline,
              title: "Informações pessoais",
              description: "Nome, email e telefone",
              onTap: () {
                print("Clicou em Informações pessoais");
              },
            ),
          ],
        ),
      ),
    );
  }
}
