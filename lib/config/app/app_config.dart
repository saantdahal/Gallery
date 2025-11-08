import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AppConfiguration {
  static String get appName => 'Gallery';

  static String get devApiUrl => dotenv.env['DEV_API_URL'] ?? '';
  static String get prodApiUrl => dotenv.env['PROD_API_URL'] ?? '';

  static String get authRequiredLabelKey =>
      dotenv.env['AUTH_REQUIRED_LABEL_KEY'] ?? 'authRequired';
}
