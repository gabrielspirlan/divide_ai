import 'package:divide_ai/components/transaction/bill_card.dart';
import 'package:divide_ai/components/transaction/spent_card.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/components/users/user_card.dart';
import 'package:divide_ai/enums/transaction_type.dart';
import 'package:divide_ai/theme/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null); // 🔹 inicializa locale pt_BR
  Intl.defaultLocale = 'pt_BR'; // 🔹 define como padrão global
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
      appBar: CustomAppBar(
        "Olá Luiz",
        description: "Gerencie seus grupos de despesas",
        icon: Icon(Icons.abc_sharp),
        tapIcon: () => {print("Clicou aqui!")},
      ),
      // appBar: AppBar(
      //   title: const Text("DivideAi"),

      //   actions: [
      //     IconButton(
      //       icon: Icon(HugeIcons.strokeRoundedSettings01),
      //       onPressed: () => print("Editar"),
      //     ),
      //   ],
      // ),
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
