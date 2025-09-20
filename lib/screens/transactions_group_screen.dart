import 'package:divide_ai/components/transaction/transaction_card.dart' as card;
import 'package:divide_ai/components/ui/button.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/components/ui/info_card.dart';
import 'package:divide_ai/components/ui/special_info_card.dart';
import 'package:divide_ai/models/data/group.dart';
import 'package:divide_ai/models/data/transaction.dart';
import 'package:divide_ai/models/data/user.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class TransactionsGroupScreen extends StatefulWidget {
  final int groupId;

  const TransactionsGroupScreen({super.key, required this.groupId});

  @override
  State<TransactionsGroupScreen> createState() =>
      TransactionsGroupScreenState();
}

class TransactionsGroupScreenState extends State<TransactionsGroupScreen> {
  @override
  Widget build(BuildContext context) {
    final group = groups.firstWhere((g) => g.id == widget.groupId);

    final groupTransactions = transactions
        .where((t) => t.groupId == widget.groupId)
        .toList();

    double individualTotal = 0.0;
    double sharedTotal = 0.0;
    int totalItems = groupTransactions.length;

    for (final transaction in groupTransactions) {
      if (transaction.participantIds.length == 1) {
        individualTotal += transaction.value;
      } else {
        sharedTotal += transaction.value;
      }
    }

    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Scaffold(
      appBar: CustomAppBar(
        group.name,
        description: group.description,
        icon: HugeIcons.strokeRoundedAnalytics01,
      ),

      body: ListView(
        children: [
          // Cards de informações
          Padding(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
            child: Column(
              spacing: 5,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SpecialInfoCard(
                        "Total da Comanda",
                        value: formatter.format(individualTotal + sharedTotal),
                        description: "$totalItems itens",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InfoCard(
                        icon: HugeIcons.strokeRoundedUser02,
                        title: "Individuais",
                        value: formatter.format(individualTotal),
                        colorOption: InfoCardColor.green,
                      ),
                    ),
                    Expanded(
                      child: InfoCard(
                        icon: HugeIcons.strokeRoundedUserMultiple02,
                        title: "Compartilhados",
                        value: formatter.format(sharedTotal),
                        colorOption: InfoCardColor.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Cabeçalho da seção de gastos
          Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Gastos do Grupo",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                Button(
                  text: "Adicionar gasto",
                  icon: Icons.add,
                  onPressed: () => print("Nova Transação"),
                  size: ButtonSize.small,
                ),
              ],
            ),
          ),

          // Lista de transações ou estado vazio
          if (groupTransactions.isEmpty)
            SizedBox(
              height: 300,
              child: Center(
                child: Column(
                  spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      HugeIcons.strokeRoundedInvoice01,
                      size: 64,
                      color: Colors.grey,
                    ),
                    Text(
                      "Nenhuma transação encontrada",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ...groupTransactions.map((transaction) {
              final participantNames = transaction.participantIds
                  .map((id) => users.firstWhere((u) => u.id == id).name)
                  .toList();

              final transactionForCard = card.Transaction(
                title: transaction.description,
                value: transaction.value,
                date: transaction.date,
                participants: participantNames,
              );

              return card.TransactionCard(transactionForCard);
            }),
        ],
      ),
    );
  }
}
