class UserBill {
  final String userId;
  final String userName;
  final double individualExpenses;
  final double sharedExpenses;
  final double totalToPay;

  UserBill({
    required this.userId,
    required this.userName,
    required this.individualExpenses,
    required this.sharedExpenses,
    required this.totalToPay,
  });

  factory UserBill.fromJson(Map<String, dynamic> json) {
    return UserBill(
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      individualExpenses: (json['individualExpenses'] as num?)?.toDouble() ?? 0.0,
      sharedExpenses: (json['sharedExpenses'] as num?)?.toDouble() ?? 0.0,
      totalToPay: (json['totalToPay'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'individualExpenses': individualExpenses,
      'sharedExpenses': sharedExpenses,
      'totalToPay': totalToPay,
    };
  }
}

class GroupBillResponse {
  final String groupId;
  final String groupName;
  final double totalExpenses;
  final double totalIndividualExpenses;
  final double totalSharedExpenses;
  final List<UserBill> userBills;

  GroupBillResponse({
    required this.groupId,
    required this.groupName,
    required this.totalExpenses,
    required this.totalIndividualExpenses,
    required this.totalSharedExpenses,
    required this.userBills,
  });

  factory GroupBillResponse.fromJson(Map<String, dynamic> json) {
    return GroupBillResponse(
      groupId: json['groupId'] as String? ?? '',
      groupName: json['groupName'] as String? ?? '',
      totalExpenses: (json['totalExpenses'] as num?)?.toDouble() ?? 0.0,
      totalIndividualExpenses: (json['totalIndividualExpenses'] as num?)?.toDouble() ?? 0.0,
      totalSharedExpenses: (json['totalSharedExpenses'] as num?)?.toDouble() ?? 0.0,
      userBills: (json['userBills'] as List<dynamic>?)
              ?.map((item) => UserBill.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'totalExpenses': totalExpenses,
      'totalIndividualExpenses': totalIndividualExpenses,
      'totalSharedExpenses': totalSharedExpenses,
      'userBills': userBills.map((bill) => bill.toJson()).toList(),
    };
  }
}

