import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:divide_ai/services/session_service.dart';
import 'package:divide_ai/services/auth_service.dart';
import 'package:divide_ai/config/app_config.dart';

/// Cliente HTTP customizado que adiciona automaticamente o token de autenticação
/// (Bearer Token) em todas as requisições, exceto aquelas que são publicas.
class HttpRequest extends http.BaseClient {
  final http.Client _inner = http.Client();
  final String _baseUrl = AppConfig.baseUrl; // USA A CONFIG DE AMBIENTE
  
  // Rotas que não requerem token (apenas o path, ex: '/auth/login')
  final List<String> _publicPaths = ['/auth/login', '/auth/register']; 

  HttpRequest();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await SessionService.getToken();
    
    // Converte a URL completa para verificar apenas o caminho (path)
    final urlPath = Uri.parse(request.url.toString()).path; 

    // 1. Adiciona Token JWT se não for uma rota pública
    bool isPublic = _publicPaths.any((path) => urlPath.endsWith(path));

    if (token != null && token.isNotEmpty && !isPublic) {
      request.headers['Authorization'] = 'Bearer $token';
      debugPrint('[HttpRequest] ✅ Token adicionado: Bearer...');
    } else if (!isPublic) {
      debugPrint('[HttpRequest] ⚠️ Rota privada sem token disponível.');
    } else {
      debugPrint('[HttpRequest] Rota pública, sem necessidade de token.');
    }

    // 2. Adiciona header Content-Type
    if (!request.headers.containsKey('Content-Type')) {
      request.headers['Content-Type'] = 'application/json';
    }

    debugPrint('[HttpRequest] Enviando: ${request.method} ${request.url}');

    try {
      final response = await _inner.send(request);

      // 3. Tratamento de 401 (Unauthorized)
      if (response.statusCode == 401 && !isPublic) {
        debugPrint('[HttpRequest] ⚠️ Token inválido/expirado (401). Forçando logout.');
        // Limpa a sessão e força o logout (a navegação será tratada na UI)
        // Note: Se fosse necessário refresh token, seria implementado aqui antes do logout.
        await AuthService.logout(); 
      }
      
      return response;
    } catch (e) {
      debugPrint('[HttpRequest] ❌ Erro ao enviar requisição: $e');
      rethrow;
    }
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}

// Instância única do cliente para ser usada nos services
final authenticatedHttpClient = HttpRequest();