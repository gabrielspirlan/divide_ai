import 'package:divide_ai/models/enums/transaction_type.dart';
import 'package:divide_ai/models/data/user.dart';

class Transaction {
  final String id;
  final String description;
  final double value;
  final List<String> participants; // IDs dos participantes como String
  final List<String> participantNames;
  final String group; // ID do grupo como String
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

  // FACTORY CONSTRUCTOR para API/JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    print('=== DEBUG Transaction.fromJson ===');
    print('JSON completo: $json');
    print('Chaves disponíveis: ${json.keys.toList()}');

    // ID como String
    final String id = json['id']?.toString() ?? '0';
    print('ID: $id');

    // Group como String
    final String group = json['group']?.toString() ?? '';
    print('Group: $group');

    // Participants como List<String>
    final List<dynamic> participantsJson = json['participants'] ?? [];
    final List<String> participants = participantsJson.map((p) => p.toString()).toList();
    print('Participants: $participants');

    // ParticipantNames como List<String>
    final List<dynamic> namesJson = json['participantNames'] ?? [];
    final List<String> participantNames = namesJson.map((name) => name.toString()).toList();
    print('ParticipantNames: $participantNames');

    // Value
    final double value = (json['value'] as num?)?.toDouble() ?? 0.0;
    print('Value: $value');

    // ValuePerPerson
    final double valuePerPerson = (json['valuePerPerson'] as num?)?.toDouble() ?? 0.0;
    print('ValuePerPerson: $valuePerPerson');

    // Date
    final String dateString = json['date'] as String? ?? DateTime.now().toIso8601String();
    final DateTime date = DateTime.parse(dateString);
    print('Date: $date');

    // Description
    final String description = json['description'] as String? ?? 'N/A';
    print('Description: $description');

    print('=== END DEBUG ===');

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