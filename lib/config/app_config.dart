import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // LÊ A VARIÁVEL DE AMBIENTE DIRETAMENTE DO ARQUIVO .ENV
  static String get baseUrl => dotenv.env['DIVIDE_AI_BASE_URL'] ?? 'https://divide-ai-api-i8en.onrender.com';
}