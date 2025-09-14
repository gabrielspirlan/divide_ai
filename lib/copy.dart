import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/components/users/user_card.dart';
import 'package:flutter/material.dart';

class Copy extends StatelessWidget {
  const Copy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        "Olá Gabriel",
        description: "Gerencie seus grupos de despesas",
        icon: Icon(Icons.abc_sharp),
        tapIcon: () => {print("Clicou aqui!")},
      ),
      body: Column(
        children: [
          UserCard(
            User("Luiz Silva", email: "luiz@exemplo.com"),
            onTap: () => print("Editar perfil"),
          ),
        ],
      ),
    );
  }
}
