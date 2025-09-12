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

  SpentCard(this.spent);

  @override
  Widget build(BuildContext context) {
    final title = spent.transactionType == TransactionType.individual
        ? "Individual"
        : "Compartilhado";

    final icon = spent.transactionType == TransactionType.individual
        ? HugeIcons.strokeRoundedUserCheck02
        : HugeIcons.strokeRoundedUserMultiple03;
    final color = spent.transactionType == TransactionType.individual
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.onPrimaryFixed;

    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Card(
      color: Theme.of(context).colorScheme.onBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 12),
                  Text(title, style: TextStyle(color: color, fontSize: 12)),
                ],
              ),
              Text(
                formatter.format(spent.value),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
