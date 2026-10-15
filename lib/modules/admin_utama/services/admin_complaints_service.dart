import 'package:dio/dio.dart';
import 'package:elingk/core/network/api_client.dart';

class AdminComplaintsService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getComplaints({
    int page = 1,
    String? status,
    bool belumDidelegasikan = false,
  }) async {
    final response = await _dio.get(
      '/admin/complaints',
      queryParameters: {
        'page': page,
        if (status != null && status.isNotEmpty) 'status': status,
        if (belumDidelegasikan) 'belum_didelegasikan': 1,
      },
    );

    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> getComplaintDetail(int id) async {
    final response = await _dio.get('/admin/complaints/$id');
    final result = _asMap(response.data);

    if (result['status'] != 'success' || result['data'] is! Map) {
      throw Exception(result['message'] ?? 'Gagal mengambil detail pengaduan.');
    }

    return Map<String, dynamic>.from(result['data'] as Map);
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await _dio.get('/admin/complaint-categories');
    return _extractList(response.data);
  }

  Future<List<Map<String, dynamic>>> getUnits() async {
    final response = await _dio.get('/admin/units');
    return _extractList(response.data);
  }

  Future<Map<String, dynamic>> setCategory({
    required int complaintId,
    required int categoryId,
  }) async {
    final response = await _dio.patch(
      '/admin/admin/complaints/$complaintId/category',
      data: {'category_id': categoryId},
    );

    return _validateActionResponse(
      response.data,
      fallbackMessage: 'Gagal menentukan kategori pengaduan.',
    );
  }

  Future<Map<String, dynamic>> delegate({
    required int complaintId,
    required int unitId,
    String? catatan,
  }) async {
    final response = await _dio.post(
      '/admin/complaints/$complaintId/delegate',
      data: {
        'unit_id': unitId,
        if (catatan != null && catatan.trim().isNotEmpty)
          'catatan': catatan.trim(),
      },
    );

    return _validateActionResponse(
      response.data,
      fallbackMessage: 'Gagal mendelegasikan pengaduan.',
    );
  }

  Future<Map<String, dynamic>> reject({
    required int complaintId,
    required String catatan,
  }) async {
    final response = await _dio.post(
      '/admin/complaints/$complaintId/reject',
      data: {'catatan': catatan.trim()},
    );

    return _validateActionResponse(
      response.data,
      fallbackMessage: 'Gagal menolak pengaduan.',
    );
  }

  Map<String, dynamic> _validateActionResponse(
    dynamic value, {
    required String fallbackMessage,
  }) {
    final result = _asMap(value);

    if (result['status'] != 'success') {
      throw Exception(result['message'] ?? fallbackMessage);
    }

    return result;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    throw Exception('Format respons server tidak valid.');
  }

  List<Map<String, dynamic>> _extractList(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    if (value is Map) {
      final map = Map<String, dynamic>.from(value);

      // Mendukung respons Laravel berbentuk:
      // {data: [...]}
      // {data: {data: [...]}}
      for (final key in ['data', 'items', 'results']) {
        if (map.containsKey(key)) {
          final result = _extractList(map[key]);
          if (result.isNotEmpty || map[key] is List) {
            return result;
          }
        }
      }
    }

    return [];
  }
}
