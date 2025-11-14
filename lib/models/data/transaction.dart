import 'package:divide_ai/models/enums/transaction_type.dart';
import 'package:divide_ai/models/data/user.dart';

class Transaction {
  final String id;
  final String description;
  final double value;
  final List<String> participants; 
  final List<String> participantNames;
  final String group;
  final DateTime date;
  final double valuePerPerson;

  Transaction({
    required this.id,
    required this.description,
    required this.value,
    required this.participants,
    required this.participantNames,
    required this.group,
    required this.date,
    required this.valuePerPerson,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final String id = json['id']?.toString() ?? '0';
    final String group = json['group']?.toString() ?? '';
    final List<dynamic> participantsJson = json['participants'] ?? [];
    final List<String> participants = participantsJson.map((p) => p.toString()).toList();
    final List<dynamic> namesJson = json['participantNames'] ?? [];
    final List<String> participantNames = namesJson.map((name) => name.toString()).toList();
    final double value = (json['value'] as num?)?.toDouble() ?? 0.0;
    final double valuePerPerson = (json['valuePerPerson'] as num?)?.toDouble() ?? 0.0;
    final String dateString = json['date'] as String? ?? DateTime.now().toIso8601String();
    final DateTime date = DateTime.parse(dateString);
    final String description = json['description'] as String? ?? 'N/A';

    return Transaction(
      id: id,
      description: description,
      value: value,
      participants: participants,
      participantNames: participantNames,
      group: group,
      date: date,
      valuePerPerson: valuePerPerson,
    );
  }
}