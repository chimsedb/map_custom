import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static AppConfig? _instance;

  static AppConfig get instance => _instance ??= AppConfig._();

  String baseUrl = dotenv.env['BASE_URL'] ?? '';
}
