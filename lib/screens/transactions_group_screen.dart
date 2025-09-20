import 'package:divide_ai/components/transaction/transaction_card.dart' as card;
import 'package:divide_ai/components/ui/button.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/models/data/group.dart';
import 'package:divide_ai/models/data/transaction.dart';
import 'package:divide_ai/models/data/user.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

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

    return Scaffold(
      appBar: CustomAppBar(
        group.name,
        description: group.description,
        icon: HugeIcons.strokeRoundedSettings01,
      ),

      body: Column(
        children: [
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
          Expanded(
            child: groupTransactions.isEmpty
                ? Center(
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
                  )
                : ListView.builder(
                    itemCount: groupTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = groupTransactions[index];

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
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
