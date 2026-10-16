class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'http://192.168.1.6:8000/api/v1';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
