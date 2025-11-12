import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:divide_ai/config/app_config.dart';
import 'package:divide_ai/services/http_request.dart';
import 'package:divide_ai/models/data/user.dart';
import 'package:divide_ai/models/data/user_request.dart';
import 'package:divide_ai/services/session_service.dart'; // IMPORT NECESSÁRIO

class UserService {
  final String _baseUrl = AppConfig.baseUrl;
  
  // POST /users: Cadastro de novo usuário
  Future<User> registerUser(UserRequest userRequest) async {
    try {
      final url = Uri.parse('$_baseUrl/users');

      // Usando o método estático http.post para rotas públicas (cadastro).
      final response = await http.post(
        url,
        body: jsonEncode(userRequest.toJson()),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return User.fromJson(json);
      } else {
        throw Exception('Falha ao cadastrar usuário: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro em registerUser: $e');
      rethrow;
    }
  }
  
  // NOVO MÉTODO: Obtém o usuário logado (usado na SettingsScreen e EditUserScreen)
  Future<User> getLoggedUser() async {
    final userId = await SessionService.getUserId(); // Pega o ID salvo

    if (userId == null || userId.isEmpty) {
      // Se não houver ID salvo, lança uma exceção para a UI tratar
      throw Exception('Nenhum usuário logado encontrado.');
    }

    // Reutiliza o método existente getUserById para buscar os dados via API
    return getUserById(userId);
  }


  // GET /users: Lista todos os usuários (rota paginada)
  Future<List<User>> getAllUsers() async {
    try {
      final url = Uri.parse('$_baseUrl/users');
      final response = await authenticatedHttpClient.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        // Assumindo que a lista de usuários está em "content" (padrão paginado)
        final List<dynamic> jsonList = responseData['content'] ?? []; 
        return jsonList.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar usuários: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro em getAllUsers: $e');
      rethrow;
    }
  }

  // GET /users/{id}
  Future<User> getUserById(String id) async {
    try {
      final url = Uri.parse('$_baseUrl/users/$id');
      final response = await authenticatedHttpClient.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return User.fromJson(json);
      } else {
        throw Exception('Falha ao carregar usuário $id: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro em getUserById: $e');
      rethrow;
    }
  }

  // PUT /users/{id}: Edita informações do usuário
  Future<User> updateUser(String id, UserRequest userRequest) async {
    try {
      final url = Uri.parse('$_baseUrl/users/$id');
      final response = await authenticatedHttpClient.put(
        url,
        body: jsonEncode(userRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return User.fromJson(json);
      } else {
        throw Exception('Falha ao atualizar usuário: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro em updateUser: $e');
      rethrow;
    }
  }
}