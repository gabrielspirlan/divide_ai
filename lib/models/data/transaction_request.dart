class TransactionRequest {
  final String description;
  final double value;
  final List<String> participantIds;
  final String groupId;

  TransactionRequest({
    required this.description,
    required this.value,
    required this.participantIds,
    required this.groupId,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'value': value,
      'participants': participantIds,
      'group': groupId,
    };
  }
}