class ApiConfig {
  ApiConfig._();

  static const String baseUrl =
      'http://36.93.148.82:8800/central-backend/api/v1';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
