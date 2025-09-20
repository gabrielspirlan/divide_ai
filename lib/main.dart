import 'package:divide_ai/components/group/group_card.dart';
import 'package:divide_ai/components/ui/input.dart'; 
import 'package:divide_ai/components/ui/button.dart'; 
import 'package:divide_ai/components/ui/info_card.dart'; 
import 'package:divide_ai/theme/app_theme.dart';
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
      appBar: AppBar(title: const Text("Teste de Componentes")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Inputs
            Input(
              label: "Nome",
              hint: "Digite seu nome",
              icon: Icons.person,
              controller: nameController,
              size: InputSize.large,
            ),
            const SizedBox(height: 16),
            Input(
              label: "Email",
              hint: "Digite seu email",
              icon: HugeIcons.strokeRoundedMail01,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              size: InputSize.medium,
            ),
            const SizedBox(height: 16),
            Input(
              label: "Senha",
              hint: "Digite sua senha",
              icon: Icons.lock,
              obscureText: true,
              controller: passwordController,
              size: InputSize.small,
            ),
            const SizedBox(height: 24),

            // GroupCard
            GroupCard(
              Group(
                "Hamburgueria",
                "Brooks Sabadão",
                "Gabriel, Henrique, Luiz",
                300.00,
                5,
                Theme.of(context).primaryColor,
              ),
              onTap: () {
                debugPrint("Clicou em Informações pessoais");
              },
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: InfoCard(
                    icon: Icons.group,
                    title: "Grupos",
                    value: "4",
                    colorOption: InfoCardColor.blue, 
                    size: InfoCardSize.medium,
                    alignment: InfoCardAlignment.vertical,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InfoCard(
                    icon: Icons.attach_money,
                    title: "Total",
                    value: "R\$ 1177.00",
                    colorOption: InfoCardColor.green,
                    size: InfoCardSize.medium,
                    alignment: InfoCardAlignment.vertical,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
