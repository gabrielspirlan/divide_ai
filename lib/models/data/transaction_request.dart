class TransactionRequest {
  final String description;
  final double value;
  final List<int> participantIds; // IDs de participantes
  final int groupId; // ID do grupo
  final DateTime date;

  TransactionRequest({
    required this.description,
    required this.value,
    required this.participantIds,
    required this.groupId,
    DateTime? date,
  }) : date = date ?? DateTime.now();


  Map<String, dynamic> toJson() {
    // O corpo da requisição deve usar as chaves da API
    return {
      'description': description,
      'value': value,
      // A API espera os IDs dos participantes como lista de Strings
      'participants': participantIds.map((id) => id.toString()).toList(), 
      // A API espera o ID do grupo como String
      'group': groupId.toString(), 
      // A API espera a data em formato ISO 8601
      'date': date.toIso8601String(),
    };
  }
}