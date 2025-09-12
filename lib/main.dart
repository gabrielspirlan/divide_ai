import 'package:divide_ai/components/group/group_card.dart';
import 'package:divide_ai/components/transaction/spent_card.dart';
import 'package:divide_ai/components/transaction/transaction_card.dart';
import 'package:divide_ai/enums/transaction_type.dart';
import 'package:divide_ai/theme/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

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
      appBar: AppBar(title: const Text("DivideAi - Teste TransactionCard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            SpentCard(Spent(TransactionType.individual, 20.00)),
            SpentCard(Spent(TransactionType.compartilhado, 20.00)),
          ],
        ),
      ),
    );
  }
}
