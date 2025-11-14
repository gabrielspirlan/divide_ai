import 'package:divide_ai/models/data/user.dart';
import 'package:flutter/material.dart';

class GroupUsersResponse {
  final String groupId;
  final String groupName;
  final List<User> users;

  GroupUsersResponse({
    required this.groupId,
    required this.groupName,
    required this.users,
  });

  factory GroupUsersResponse.fromJson(Map<String, dynamic> json) {
    try {
      final List<dynamic> usersJson = json['users'] ?? [];
      final List<User> users = usersJson.map((userJson) {
        try {
          return User.fromJson(userJson as Map<String, dynamic>);
        } catch (e) {
          debugPrint('Erro ao parsear usuário: $e');
          debugPrint('JSON do usuário: $userJson');
          rethrow;
        }
      }).toList();

      // Converte groupId para String se vier como número
      final groupId = json['groupId']?.toString() ?? '';

      return GroupUsersResponse(
        groupId: groupId,
        groupName: json['groupName'] as String? ?? '',
        users: users,
      );
    } catch (e) {
      debugPrint('Erro ao parsear GroupUsersResponse: $e');
      debugPrint('JSON completo: $json');
      rethrow;
    }
  }
}

