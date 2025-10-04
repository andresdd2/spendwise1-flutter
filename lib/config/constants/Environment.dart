import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String apiBaseUrl = dotenv.env['API_BASE_URL'] ?? 'No hay apibaseurl';
}