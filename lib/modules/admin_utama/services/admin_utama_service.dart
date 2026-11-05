import 'package:dio/dio.dart';
import 'package:sapahub/core/network/api_client.dart';

class AdminUtamaService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _dio.get('/admin/dashboard');
    final result = _asMap(response.data);

    if (result['status'] != 'success' || result['data'] is! Map) {
      throw Exception(result['message'] ?? 'Gagal mengambil data dashboard.');
    }

    return Map<String, dynamic>.from(result['data'] as Map);
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    throw Exception('Format respons server tidak valid.');
  }
}
