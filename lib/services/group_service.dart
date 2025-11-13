import 'dart:convert';
import 'package:divide_ai/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:divide_ai/models/data/group_api_model.dart';
import 'package:divide_ai/services/session_service.dart';

class GroupService {
  static final String _baseUrl = "${AppConfig.baseUrl}/groups";

 
  static Future<List<GroupApiModel>> getGroupsByUser(String userId) async {
    final token = await SessionService.getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/user/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> content = data['content'] ?? [];
      return content.map((e) => GroupApiModel.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar grupos: ${response.statusCode}');
    }
  }

  // ✅ POST: cria um novo grupo
  static Future<void> createGroup(GroupApiModel group) async {
    final token = await SessionService.getToken();

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': group.name,
        'description': group.description,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
        'Erro ao criar grupo: ${response.statusCode} → ${response.body}',
      );
    }
  }
}
