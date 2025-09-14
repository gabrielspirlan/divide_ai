import 'package:divide_ai/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';

class Spent {
  TransactionType transactionType;
  double value;

  Spent(this.transactionType, this.value);
}

class SpentCard extends StatelessWidget {
  final Spent spent;

  const SpentCard(this.spent, {super.key});

  @override
  Widget build(BuildContext context) {
    final title = spent.transactionType == TransactionType.individual
        ? "Individual"
        : "Compartilhado";

    final icon = spent.transactionType == TransactionType.individual
        ? HugeIcons.strokeRoundedUserCheck02
        : HugeIcons.strokeRoundedUserMultiple03;
    final color = spent.transactionType == TransactionType.individual
        ? Theme.of(context).colorScheme.onSecondaryFixed
        : Theme.of(context).colorScheme.onPrimaryFixed;

    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 14),
                Text(title, style: TextStyle(color: color, fontSize: 14)),
              ],
            ),
            Text(
              formatter.format(spent.value),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
