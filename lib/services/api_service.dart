import 'dart:convert';
import 'package:divide_ai/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:divide_ai/services/session_service.dart';

class ApiService {
  static final String baseUrl = AppConfig.baseUrl;

  // GET genérico
  static Future<http.Response> get(String endpoint) async {
    final headers = await _buildHeaders();
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(url, headers: headers);
      _checkResponse(response);
      return response;
    } catch (e) {
      debugPrint('Erro em ApiService.get: $e');
      rethrow;
    }
  }

  
  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _buildHeaders();
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(url, headers: headers, body: jsonEncode(body));
      _checkResponse(response);
      return response;
    } catch (e) {
      debugPrint('Erro em ApiService.post: $e');
      rethrow;
    }
  }

  
  static Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final headers = await _buildHeaders();
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.put(url, headers: headers, body: jsonEncode(body));
      _checkResponse(response);
      return response;
    } catch (e) {
      debugPrint('Erro em ApiService.put: $e');
      rethrow;
    }
  }

  
  static Future<Map<String, String>> _buildHeaders() async {
    final token = await SessionService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static void _checkResponse(http.Response response) {
    if (response.statusCode == 401) {
      throw Exception('Não autorizado — token ausente ou inválido');
    } else if (response.statusCode >= 400) {
      throw Exception('Erro HTTP ${response.statusCode}: ${response.body}');
    }
  }
}
