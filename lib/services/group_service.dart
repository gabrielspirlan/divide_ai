import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:divide_ai/models/data/group_api_model.dart';
import 'package:divide_ai/models/data/user.dart';
import 'package:divide_ai/models/data/group_users_response.dart';
import 'package:divide_ai/models/data/group_bill_response.dart';
import 'package:divide_ai/services/session_service.dart';
import 'package:divide_ai/config/app_config.dart';
import 'package:divide_ai/services/http_request.dart';
import 'package:flutter/material.dart';

class GroupService {
  final String _baseUrl = AppConfig.baseUrl;

  // NOVO: getGroupsByUser não precisa mais ser static, mas o método deve ser mantido
  Future<List<GroupApiModel>> getGroupsByUser(String userId) async {
    try {
      final url = Uri.parse('$_baseUrl/groups/user/$userId');

      // ALTERADO: Usa o cliente autenticado (HttpRequest)
      final response = await authenticatedHttpClient.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> content = data['content'] ?? [];
        return content.map((e) => GroupApiModel.fromJson(e)).toList();
      } else {
        throw Exception('Erro ao buscar grupos: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro em getGroupsByUser: $e');
      rethrow;
    }
  }

  // MÉTODO ADICIONADO: GET /groups/{groupId}/users (necessário para a CreateTransactionScreen)
  // Nota: GroupId é string na rota da API
  Future<List<User>> getGroupMembers(String groupId) async {
    try {
      final url = Uri.parse('$_baseUrl/groups/$groupId/users');

      // ALTERADO: Usa o cliente autenticado (HttpRequest)
      final response = await authenticatedHttpClient.get(url);

      if (response.statusCode == 200) {
        // A API retorna diretamente a lista de usuários
        final List<dynamic> jsonList = jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        // Mapeia para o modelo User (que agora tem IDs String)
        return jsonList.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception(
          'Falha ao carregar membros do grupo: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Erro em getGroupMembers: $e');
      rethrow;
    }
  }

  // NOVO MÉTODO: GET /groups/{groupId}/users com estrutura completa
  Future<GroupUsersResponse> getGroupUsersWithDetails(String groupId) async {
    try {
      final url = Uri.parse('$_baseUrl/groups/$groupId/users');

      final response = await authenticatedHttpClient.get(url);

      if (response.statusCode == 200) {
        debugPrint('Response body: ${response.body}');
        final Map<String, dynamic> json = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        debugPrint('JSON parsed: $json');
        return GroupUsersResponse.fromJson(json);
      } else {
        throw Exception(
          'Falha ao carregar membros do grupo: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Erro em getGroupUsersWithDetails: $e');
      rethrow;
    }
  }

  // ✅ POST: cria um novo grupo
  Future<void> createGroup(GroupApiModel group) async {
    try {
      final url = Uri.parse('$_baseUrl/groups');

      // Usa o toJson() do GroupApiModel que já tem todos os campos necessários
      final body = jsonEncode(group.toJson());

      debugPrint('Criando grupo com body: $body');

      // ALTERADO: Usa o cliente autenticado (HttpRequest)
      final response = await authenticatedHttpClient.post(
        url,
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception(
          'Erro ao criar grupo: ${response.statusCode} → ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Erro ao criar grupo: $e');
      rethrow;
    }
  }

  // GET /groups/{id}/bill - Busca a divisão de comanda do grupo
  Future<GroupBillResponse> getGroupBill(String groupId) async {
    try {
      final url = Uri.parse('$_baseUrl/groups/$groupId/bill');

      final response = await authenticatedHttpClient.get(url);

      debugPrint('Response status getGroupBill: ${response.statusCode}');
      debugPrint('Response body getGroupBill: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return GroupBillResponse.fromJson(json);
      } else {
        throw Exception(
          'Falha ao carregar divisão da comanda: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Erro em getGroupBill: $e');
      rethrow;
    }
  }

  // GET /groups/{id} - Busca um grupo específico
  Future<GroupApiModel> getGroupById(String groupId) async {
    try {
      final url = Uri.parse('$_baseUrl/groups/$groupId');

      final response = await authenticatedHttpClient.get(url);

      debugPrint('Response status getGroupById: ${response.statusCode}');
      debugPrint('Response body getGroupById: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return GroupApiModel.fromJson(json);
      } else {
        throw Exception(
          'Falha ao carregar grupo: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Erro em getGroupById: $e');
      rethrow;
    }
  }

  // PUT /groups/{id} - Atualiza um grupo
  Future<void> updateGroup(String groupId, GroupApiModel group) async {
    try {
      final url = Uri.parse('$_baseUrl/groups/$groupId');

      final body = jsonEncode(group.toJson());

      debugPrint('Atualizando grupo $groupId com body: $body');

      final response = await authenticatedHttpClient.put(
        url,
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Response status updateGroup: ${response.statusCode}');
      debugPrint('Response body updateGroup: ${response.body}');

      if (response.statusCode != 201 && response.statusCode != 204) {
        throw Exception(
          'Erro ao atualizar grupo: ${response.statusCode} → ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Erro ao atualizar grupo: $e');
      rethrow;
    }
  }

  // DELETE /groups/{id} - Exclui um grupo
  Future<void> deleteGroup(String groupId) async {
    try {
      final url = Uri.parse('$_baseUrl/groups/$groupId');

      final response = await authenticatedHttpClient.delete(url);

      debugPrint('Response status deleteGroup: ${response.statusCode}');
      debugPrint('Response body deleteGroup: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Erro ao excluir grupo: ${response.statusCode} → ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Erro ao excluir grupo: $e');
      rethrow;
    }
  }
}
