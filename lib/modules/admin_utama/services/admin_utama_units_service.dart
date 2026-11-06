import 'package:dio/dio.dart';
import 'package:sapahub/core/network/api_client.dart';

class AdminUtamaUnitsService {
  final Dio _dio = ApiClient.dio;

  // ============================================================
  // GET LIST
  // ============================================================

  Future<Map<String, dynamic>> getUnits({
    int page = 1,
    int perPage = 15,
    bool? aktif,
    String? search,
  }) async {
    final response = await _dio.get(
      '/admin/units',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (aktif != null) 'aktif': aktif ? 1 : 0,
        if (search != null && search.trim().isNotEmpty) 'q': search.trim(),
      },
    );

    return _asMap(response.data);
  }

  // ============================================================
  // GET DETAIL
  // ============================================================

  Future<Map<String, dynamic>> getUnitDetail(int id) async {
    final response = await _dio.get('/admin/units/$id');

    final result = _asMap(response.data);

    if (result['status'] != 'success' || result['data'] is! Map) {
      throw Exception(result['message'] ?? 'Gagal mengambil detail unit.');
    }

    return Map<String, dynamic>.from(result['data']);
  }

  // ============================================================
  // CREATE
  // ============================================================

  Future<Map<String, dynamic>> createUnit(Map<String, dynamic> data) async {
    final response = await _dio.post('/admin/units', data: data);

    return _validateResponse(response.data, 'Gagal menambahkan unit.');
  }

  // ============================================================
  // UPDATE
  // ============================================================

  Future<Map<String, dynamic>> updateUnit({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    final response = await _dio.put('/admin/units/$id', data: data);

    return _validateResponse(response.data, 'Gagal memperbarui unit.');
  }

  // ============================================================
  // RESPONSE HELPERS
  // ============================================================

  Map<String, dynamic> _validateResponse(
    dynamic value,
    String fallbackMessage,
  ) {
    final result = _asMap(value);

    if (result['status'] != 'success') {
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

  String getErrorMessage(dynamic error) {
    if (error is DioException) {
      final responseData = error.response?.data;

      if (responseData is Map) {
        // Pesan validasi Laravel (422).
        final errors = responseData['errors'];

        if (errors is Map) {
          final messages = <String>[];

          errors.forEach((key, value) {
            if (value is List) {
              messages.addAll(value.map((e) => e.toString()));
            } else {
              messages.add(value.toString());
            }
          });

          if (messages.isNotEmpty) {
            return messages.join('\n');
          }
        }

        if (responseData['message'] != null) {
          return responseData['message'].toString();
        }
      }

      return error.message ?? 'Terjadi kesalahan komunikasi dengan server.';
    }

    return error.toString().replaceFirst('Exception: ', '');
  }
}
