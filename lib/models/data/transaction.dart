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

  // Construtor privado para inicializar todos os campos diretamente (usado pelo fromJson e pelo construtor principal).
  Transaction._internal({
    required this.id,
    required this.description,
    required this.value,
    required this.participantIds,
    required this.groupId,
    required this.date,
  }) {
    if (participantIds.isEmpty) {
      throw ArgumentError("Participants não pode ser vazio");
    }
  }

  // Construtor principal para instâncias criadas localmente (CORRIGIDO: usa parâmetros normais).
  Transaction(
    String description, { // Não usa 'this.'
    required double value, // Não usa 'this.'
    required List<int> participantIds,
    required int groupId,
    DateTime? date,
  }) : this._internal(
         id: _nextId++,
         description: description, // Passa a variável normal para o construtor interno
         value: value,
         participantIds: participantIds,
         groupId: groupId,
         date: date ?? DateTime.now(),
       );

  // FACTORY CONSTRUCTOR para API/JSON (mantido com correções de segurança)
  factory Transaction.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] is int) ? json['id'] as int : int.tryParse(json['id'] ?? '0') ?? 0;
    
    final groupId = (json['group'] is int) ? json['group'] as int : int.tryParse(json['group'] ?? '0') ?? 0;
    
    final List<dynamic> idsJson = json['participants'] ?? [];
    
    final List<int> participantIds = idsJson
        .map((idStr) => int.tryParse(idStr.toString()) ?? 0)
        .where((id) => id > 0)
        .toList();

    final dateString = json['date'] as String? ?? DateTime.now().toIso8601String();
    final date = DateTime.parse(dateString);

    return Transaction._internal(
      id: id,
      description: json['description'] as String? ?? 'N/A',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      participantIds: participantIds,
      groupId: groupId,
      date: date,
    );
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
    value: 10.00,
    participantIds: [1, 2, 3, 4],
    groupId: 2,
  ),
  Transaction(
    "Espetinho de Queijo",
    value: 10.00,
    participantIds: [1],
    groupId: 2,
  ),
  Transaction(
    "Espetinho de Carne",
    value: 15.00,
    participantIds: [2],
    groupId: 2,
  ),
  Transaction(
    "Espetinho de Frango",
    value: 15.00,
    participantIds: [3],
    groupId: 2,
  ),
  Transaction(
    "Espetinho de Coração",
    value: 10.00,
    participantIds: [4],
    groupId: 2,
  ),
];
