import 'package:divide_ai/components/transaction/spent_card.dart';
import 'package:divide_ai/models/data/group_bill_response.dart';
import 'package:divide_ai/models/enums/transaction_type.dart';
import 'package:divide_ai/models/components/spent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserBillCard extends StatelessWidget {
  final UserBill userBill;

  const UserBillCard(this.userBill, {super.key});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Card(
      color: Theme.of(context).colorScheme.onBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: IntrinsicHeight(
          child: Column(
            spacing: 10,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      userBill.userName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
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
                        formatter.format(userBill.totalToPay),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                      const Text(
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
                    Spent(TransactionType.individual, userBill.individualExpenses),
                  ),
                  SpentCard(
                    Spent(
                      TransactionType.compartilhado,
                      userBill.sharedExpenses,
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

