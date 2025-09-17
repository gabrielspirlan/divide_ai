import 'package:divide_ai/models/enums/transaction_type.dart';
import 'package:divide_ai/models/data/user.dart';

class Transaction {
  static int _nextId = 1;
  final int id;
  final String description;
  final double value;
  final DateTime date;
  final List<int> participantIds;
  final int groupId;
  final TransactionType type;

  Transaction(
    this.description, {
    required this.value,
    required this.date,
    required this.participantIds,
    required this.type,
    required this.groupId,
  }) : id = _nextId++ {
    if (participantIds.isEmpty) {
      throw ArgumentError("Participants não pode ser vazio");
    }
    if (type == TransactionType.individual && participantIds.length > 1) {
      throw ArgumentError(
        "Uma transação individual deve ter apenas um participante!",
      );
    }
    if (type == TransactionType.compartilhado && participantIds.length < 2) {
      throw ArgumentError(
        "Uma transação compartilhada deve ter pelo menos dois participantes!",
      );
    }
  }
}

List<Transaction> transactions = [
  Transaction(
    "X-Tudão",
    value: 29.00,
    date: new DateTime(2025, 09, 16),
    participantIds: [1],
    type: TransactionType.individual,
    groupId: 1,
  ),
];
