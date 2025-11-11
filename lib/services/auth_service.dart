import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:divide_ai/models/auth_response.dart';
import 'package:divide_ai/services/session_service.dart';

class AuthService {
  static const String _baseUrl = 'https://divide-ai-api-i8en.onrender.com';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  // POST /auth/login
  Future<AuthResponse> login(String email, String password) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/login');
      final body = jsonEncode({
        'email': email,
        'password': password,
      });

      final response = await http.post(
        url,
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final authResponse = AuthResponse.fromJson(json);
        
        // SALVA SESSÃO APÓS LOGIN BEM SUCEDIDO
        await SessionService.saveSession(authResponse);
        
        return authResponse;
      } else {
        // Tratar erros específicos da API se houver (ex: 401 Unauthorized)
        throw Exception('Falha no login: Credenciais inválidas ou erro do servidor (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Erro em AuthService.login: $e');
      rethrow;
    }
  }

  // Método de logout que limpa a sessão
  static Future<void> logout() async {
    await SessionService.clearSession();
  }
}