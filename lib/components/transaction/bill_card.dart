import 'package:divide_ai/components/transaction/spent_card.dart';
import 'package:divide_ai/models/components/bill.dart';
import 'package:divide_ai/models/enums/transaction_type.dart';
import 'package:divide_ai/models/components/spent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillCard extends StatelessWidget {
  final Bill bill;

  const BillCard(this.bill, {super.key});

  @override
  Widget build(BuildContext context) {
    final double _totalValue = bill.valueCompartilhado + bill.valueIndividual;
    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Card(
      color: Theme.of(context).colorScheme.onBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: IntrinsicHeight(
          child: Column(
            spacing: 10,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      bill.participantName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatter.format(_totalValue),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Total a pagar",
                        style: TextStyle(fontSize: 12, color: Colors.white60),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                spacing: 12,
                children: [
                  SpentCard(
                    Spent(TransactionType.individual, bill.valueIndividual),
                  ),
                  SpentCard(
                    Spent(
                      TransactionType.compartilhado,
                      bill.valueCompartilhado,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
