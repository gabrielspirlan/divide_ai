import 'package:divide_ai/components/ui/item_menu.dart';
import 'package:flutter/material.dart';
import 'package:divide_ai/theme/AppTheme.dart';
import 'package:hugeicons/hugeicons.dart'; 

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
            ItemMenu(
              icon: HugeIcons.strokeRoundedUser,
              title: "Informações pessoais",
              description: "Nome, email e telefone",
              onTap: () {
                debugPrint("Clicou em Informações pessoais");
              },
            ),
            const SizedBox(height: 12), // 
            ItemMenu(
              icon: HugeIcons.strokeRoundedShield01, 
              title: "Privacidade e segurança",
              description: "Senha e autenticação",
              onTap: () {
                debugPrint("Clicou em Segurança");
              },
            ),
          ],
        ),
      ),
    );
  }
}
