class GroupApiModel {
  final String? id;
  final String name;
  final String description;
  final List<String> participants;
  final String backgroundIconColor;
  final double? totalTransactions;
  final List<String>? participantNames;

  GroupApiModel({
    this.id,
    required this.name,
    required this.description,
    required this.participants,
    required this.backgroundIconColor,
    this.totalTransactions,
    this.participantNames,
  });

  factory GroupApiModel.fromJson(Map<String, dynamic> json) {
    return GroupApiModel(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      participants: List<String>.from(json['participants'] ?? []),
      backgroundIconColor: json['backgroundIconColor'] ?? '#000000',
      totalTransactions: (json['totalTransactions'] ?? 0).toDouble(),
      participantNames: json['participantNames'] != null
          ? List<String>.from(json['participantNames'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "participants": participants,
      "backgroundIconColor": backgroundIconColor,
    };
  }
}
