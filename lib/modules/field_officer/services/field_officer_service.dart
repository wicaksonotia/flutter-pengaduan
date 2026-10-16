import 'package:dio/dio.dart';
import 'package:elingk/core/network/api_client.dart';

class FieldOfficerService {
  final Dio _dio = ApiClient.dio;

  /// Mengambil daftar tugas milik Field Officer yang login.
  Future<Map<String, dynamic>> getAssignments({int page = 1}) async {
    final response = await _dio.get(
      '/field/assignments',
      queryParameters: {'page': page},
    );

    final result = _asMap(response.data);

    if (result['status'] == 'error' ||
        (result.containsKey('success') && result['success'] == false)) {
      throw Exception(result['message'] ?? 'Gagal mengambil daftar tugas.');
    }

    return result;
  }

  /// Mengambil detail tugas berdasarkan ID assignment.
  Future<Map<String, dynamic>> getAssignmentDetail(int id) async {
    final response = await _dio.get('/field/assignments/$id');
    final result = _asMap(response.data);

    if (result['status'] == 'error' ||
        (result.containsKey('success') && result['success'] == false) ||
        result['data'] is! Map) {
      throw Exception(result['message'] ?? 'Gagal mengambil detail tugas.');
    }

    return Map<String, dynamic>.from(result['data'] as Map);
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    throw Exception('Format respons server tidak valid.');
  }
}
