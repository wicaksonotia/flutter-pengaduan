import 'package:dio/dio.dart';
import 'package:elingk/core/network/api_client.dart';

class AdminUnitService {
  final Dio _dio = ApiClient.dio;

  /// Mengambil daftar pengaduan yang ditangani unit Admin Unit.
  Future<Map<String, dynamic>> getComplaints({
    int page = 1,
    String? status,
  }) async {
    final response = await _dio.get(
      '/unit/complaints',
      queryParameters: {
        'page': page,
        if (status != null && status.isNotEmpty) 'status': status,
      },
    );

    return _asMap(response.data);
  }

  /// Mengambil detail pengaduan.
  Future<Map<String, dynamic>> getComplaintDetail(int id) async {
    final response = await _dio.get('/unit/complaints/$id');
    final result = _asMap(response.data);

    if (result['status'] == 'error' || result['data'] is! Map) {
      throw Exception(result['message'] ?? 'Gagal mengambil detail pengaduan.');
    }

    return Map<String, dynamic>.from(result['data'] as Map);
  }

  /// Mengambil Field Officer yang terdaftar pada unit tertentu.
  Future<List<Map<String, dynamic>>> getFieldOfficers({
    required int unitId,
  }) async {
    final response = await _dio.get(
      '/unit/field-officers',
      queryParameters: {'unit_id': unitId},
    );

    final result = _asMap(response.data);

    if (result['status'] == 'error') {
      throw Exception(
        result['message'] ?? 'Gagal mengambil daftar Field Officer.',
      );
    }

    return _extractList(result['data']);
  }

  /// Menugaskan pengaduan kepada Field Officer.
  Future<Map<String, dynamic>> assignFieldOfficer({
    required int complaintId,
    required int userId,
    String? catatan,
  }) async {
    final response = await _dio.post(
      '/unit/complaints/$complaintId/assign',
      data: {
        'user_id': userId,
        if (catatan != null && catatan.trim().isNotEmpty)
          'catatan': catatan.trim(),
      },
    );

    return _validateActionResponse(
      response.data,
      fallbackMessage: 'Gagal menugaskan Field Officer.',
    );
  }

  /// Memeriksa hasil penanganan Field Officer.
  ///
  /// keputusan: disetujui atau perlu_perbaikan
  Future<Map<String, dynamic>> reviewAssignment({
    required int assignmentId,
    required String keputusan,
    String? catatan,
  }) async {
    final response = await _dio.post(
      '/unit/assignments/$assignmentId/review',
      data: {
        'keputusan': keputusan,
        if (catatan != null && catatan.trim().isNotEmpty)
          'catatan': catatan.trim(),
      },
    );

    return _validateActionResponse(
      response.data,
      fallbackMessage: 'Gagal memeriksa hasil penanganan.',
    );
  }

  Map<String, dynamic> _validateActionResponse(
    dynamic value, {
    required String fallbackMessage,
  }) {
    final result = _asMap(value);

    if (result['status'] == 'error') {
      throw Exception(result['message'] ?? fallbackMessage);
    }

    if (result.containsKey('success') && result['success'] == false) {
      throw Exception(result['message'] ?? fallbackMessage);
    }

    return result;
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

  List<Map<String, dynamic>> _extractList(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    if (value is Map) {
      final map = Map<String, dynamic>.from(value);

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
