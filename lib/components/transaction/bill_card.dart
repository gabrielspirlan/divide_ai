import 'package:divide_ai/components/transaction/spent_card.dart';
import 'package:divide_ai/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';

class BillCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Luiz",
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
                        "R 39.90",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      Text("Total a Pagar", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  SpentCard(Spent(TransactionType.individual, 20.00)),
                  SpentCard(Spent(TransactionType.compartilhado, 20.00)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
