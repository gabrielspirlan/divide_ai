import 'package:divide_ai/components/group/group_card.dart';
import 'package:divide_ai/components/ui/input.dart'; // importe o seu input
import 'package:divide_ai/theme/AppTheme.dart';
import 'package:flutter/material.dart';
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
      home: const InputTestPage(),
    );
  }
}

class InputTestPage extends StatelessWidget {
  const InputTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    // controllers para teste
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Teste de Input")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                debugPrint("Clicou no grupo");
              },
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint("Nome: ${nameController.text}");
                debugPrint("Email: ${emailController.text}");
                debugPrint("Senha: ${passwordController.text}");
              },
              child: const Text("Enviar"),
            ),
          ],
        ),
      ),
    );
  }
}
