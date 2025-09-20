import 'package:divide_ai/models/enums/transaction_type.dart';
import 'package:divide_ai/models/data/user.dart';

class Transaction {
  static int _nextId = 1;
  final int id;
  final String description;
  final double value;
  final List<int> participantIds;
  final int groupId;
  final DateTime date;

  Transaction(
    this.description, {
    required this.value,
    required this.participantIds,
    required this.groupId,
    DateTime? date,
  }) : id = _nextId++,
       date = date ?? DateTime.now() {
    if (participantIds.isEmpty) {
      throw ArgumentError("Participants não pode ser vazio");
    }
  }
}

List<Transaction> transactions = [
  Transaction("X-Tudão", value: 29.00, participantIds: [1], groupId: 1),
  Transaction("X-Franca", value: 32.90, participantIds: [2], groupId: 1),
  Transaction("X-Basqueste", value: 35.50, participantIds: [3], groupId: 1),
  Transaction("X-Tudão", value: 29.00, participantIds: [4], groupId: 1),
  Transaction(
    "Coca-Cola 2 Litros",
    value: 10.00,
    participantIds: [1, 2, 3, 4],
    groupId: 1,
  ),
  Transaction(
    "Batatona Cheddar e Óleo",
    value: 24.00,
    participantIds: [1, 2, 3, 4],
    groupId: 1,
  ),
  Transaction(
    "Coca-Cola 2 litros",
    value: 15.00,
    participantIds: [1, 2, 3, 4],
    groupId: 2,
  ),
  Transaction(
    "Espetinho de Carne",
    value: 10.00,
    participantIds: [2],
    groupId: 2,
  ),
  Transaction(
    "Espetinho de Medalhão",
    value: 10.00,
    participantIds: [4],
    groupId: 2,
  ),
  Transaction(
    "Espetinho de Medalhão",
    value: 10.00,
    participantIds: [1],
    groupId: 2,
  ),
  Transaction(
    "Espetinho de Coração",
    value: 10.00,
    participantIds: [3],
    groupId: 2,
  ),
];
