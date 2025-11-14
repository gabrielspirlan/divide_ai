class UserExpensesResponse {
  final double totalExpenses;
  final double individualExpenses;
  final double sharedExpenses;

  UserExpensesResponse({
    required this.totalExpenses,
    required this.individualExpenses,
    required this.sharedExpenses,
  });

  factory UserExpensesResponse.fromJson(Map<String, dynamic> json) {
    return UserExpensesResponse(
      totalExpenses: (json['totalExpenses'] as num?)?.toDouble() ?? 0.0,
      individualExpenses: (json['individualExpenses'] as num?)?.toDouble() ?? 0.0,
      sharedExpenses: (json['sharedExpenses'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalExpenses': totalExpenses,
      'individualExpenses': individualExpenses,
      'sharedExpenses': sharedExpenses,
    };
  }
}

