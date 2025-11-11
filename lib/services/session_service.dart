import 'package:shared_preferences/shared_preferences.dart';
import 'package:divide_ai/models/auth_response.dart';

class SessionService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  // Salva os dados da sessão (Token e User ID)
  static Future<void> saveSession(AuthResponse authResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, authResponse.token);
    await prefs.setString(_userIdKey, authResponse.userId);
  }

  // Carrega o User ID (principal uso)
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }
  
  // Carrega o Token (necessário para cabeçalhos de autenticação, se aplicável)
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Verifica se o usuário está logado
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey) && prefs.containsKey(_userIdKey);
  }

  // Implementa o Logout
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
  }
}