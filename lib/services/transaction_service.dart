import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:divide_ai/models/data/transaction.dart';
import 'package:divide_ai/models/data/transaction_request.dart';
import 'package:flutter/material.dart';

class TransactionService {
  static const String _baseUrl = 'https://divide-ai-api-i8en.onrender.com';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  // 1. GET /transactions/group/{groupId} - Lida com a resposta paginada
  Future<List<Transaction>> getGroupTransactions(int groupId) async {
    try {
      // Adicionar parâmetros de paginação se necessário, aqui usando apenas o groupId
      final url = Uri.parse('$_baseUrl/transactions/group/$groupId'); 
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // A API retorna um objeto paginado, o payload de transações está em "content"
        final List<dynamic> jsonList = responseData['content'] ?? []; 
        
        return jsonList.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception(
            'Falha ao carregar transações do grupo: ${response.statusCode}');
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
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Transaction.fromJson(json);
      } else {
        throw Exception(
            'Falha ao carregar transação $id: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro em getTransactionById: $e');
      rethrow;
    }
  }

  // 3. POST /transactions
  Future<Transaction> createTransaction(
      TransactionRequest transactionRequest) async {
    try {
      final url = Uri.parse('$_baseUrl/transactions');
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(transactionRequest.toJson()),
      );

      // O print de sucesso da API mostra um status 200 (OK), não 201 (Created)
      if (response.statusCode == 200 || response.statusCode == 201) { 
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Transaction.fromJson(json);
      } else {
        throw Exception(
            'Falha ao criar transação: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Erro em createTransaction: $e');
      rethrow;
    }
  }

  // 4. PUT /transactions/{id} - Agora usa o ID na URL
  Future<Transaction> updateTransaction(
      int id, TransactionRequest transactionRequest) async {
    try {
      final url = Uri.parse('$_baseUrl/transactions/$id');
      final response = await http.put(
        url,
        headers: _headers,
        body: jsonEncode(transactionRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Transaction.fromJson(json);
      } else {
        throw Exception(
            'Falha ao atualizar transação $id: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro em updateTransaction: $e');
      rethrow;
    }
  }
}