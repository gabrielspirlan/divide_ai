import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:divide_ai/models/data/transaction.dart';
import 'package:divide_ai/models/data/transaction_request.dart';
import 'package:divide_ai/models/data/user_expenses_response.dart';
import 'package:divide_ai/config/app_config.dart';
import 'package:divide_ai/services/http_request.dart';
import 'package:flutter/material.dart';

class TransactionService {
  static final String _baseUrl = AppConfig.baseUrl;

  // 1. GET /transactions/group/{groupId}
  Future<List<Transaction>> getGroupTransactions(String groupId) async {
    try {
      final url = Uri.parse('$_baseUrl/transactions/group/$groupId');

      // USANDO CLIENTE AUTENTICADO
      final response = await authenticatedHttpClient.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> jsonList = responseData['content'] ?? [];

        return jsonList.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception(
          'Falha ao carregar transações do grupo: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Erro em getGroupTransactions: $e');
      rethrow;
    }
  }

  // 2. GET /transactions/{id}
  Future<Transaction> getTransactionById(int id) async {
    try {
      final url = Uri.parse('$_baseUrl/transactions/$id');

      // USANDO CLIENTE AUTENTICADO
      final response = await authenticatedHttpClient.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Transaction.fromJson(json);
      } else {
        throw Exception(
          'Falha ao carregar transação $id: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Erro em getTransactionById: $e');
      rethrow;
    }
  }

  // 3. POST /transactions
  Future<Transaction> createTransaction(
    TransactionRequest transactionRequest,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl/transactions');

      // USANDO CLIENTE AUTENTICADO
      final response = await authenticatedHttpClient.post(
        url,
        body: jsonEncode(transactionRequest.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Transaction.fromJson(json);
      } else {
        throw Exception(
          'Falha ao criar transação: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Erro em createTransaction: $e');
      rethrow;
    }
  }

  // 4. PUT /transactions/{id}
  Future<Transaction> updateTransaction(
    int id,
    TransactionRequest transactionRequest,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl/transactions/$id');

      // USANDO CLIENTE AUTENTICADO
      final response = await authenticatedHttpClient.put(
        url,
        body: jsonEncode(transactionRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Transaction.fromJson(json);
      } else {
        throw Exception(
          'Falha ao atualizar transação $id: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Erro em updateTransaction: $e');
      rethrow;
    }
  }

  // 5. GET /transactions/user/{userId}/total
  Future<UserExpensesResponse> getUserTotalExpenses(String userId) async {
    try {
      final url = Uri.parse('$_baseUrl/transactions/user/$userId/totals');

      // USANDO CLIENTE AUTENTICADO
      final response = await authenticatedHttpClient.get(url);

      debugPrint('Response status getUserTotalExpenses: ${response.statusCode}');
      debugPrint('Response body getUserTotalExpenses: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return UserExpensesResponse.fromJson(json);
      } else {
        throw Exception(
          'Falha ao carregar totais do usuário: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Erro em getUserTotalExpenses: $e');
      rethrow;
    }
  }
}
