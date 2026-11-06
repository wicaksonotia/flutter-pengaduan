import 'package:dio/dio.dart';
import 'package:sapahub/core/network/api_client.dart';

class AdminUtamaUnitsService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getUnits({
    int page = 1,
    int perPage = 15,
    int? instansiId,
    bool? aktif,
    String? search,
  }) async {
    final response = await _dio.get(
      '/admin/units',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'instansi_id': ?instansiId,
        if (aktif != null) 'aktif': aktif ? 1 : 0,
        if (search != null && search.trim().isNotEmpty) 'q': search.trim(),
      },
    );

    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> getUnitDetail(int id) async {
    final response = await _dio.get('/admin/units/$id');
    final result = _asMap(response.data);

    if (result['status'] != 'success' || result['data'] is! Map) {
      throw Exception(result['message'] ?? 'Gagal mengambil detail unit.');
    }

    return Map<String, dynamic>.from(result['data']);
  }

  Future<List<Map<String, dynamic>>> getInstansiOptions() async {
    final response = await _dio.get('/admin/instansi');

    final result = _asMap(response.data);

    if (result['status'] != 'success') {
      throw Exception(result['message'] ?? 'Gagal mengambil daftar instansi.');
    }

    return _extractList(result['data']);
  }

  Future<Map<String, dynamic>> createUnit(Map<String, dynamic> data) async {
    final response = await _dio.post('/admin/units', data: data);

    return _validateResponse(response.data, 'Gagal menambahkan unit.');
  }

  Future<Map<String, dynamic>> updateUnit({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    final response = await _dio.put('/admin/units/$id', data: data);

    return _validateResponse(response.data, 'Gagal memperbarui unit.');
  }

  Future<Map<String, dynamic>> deactivateUnit(int id) async {
    final response = await _dio.delete('/admin/units/$id');

    return _validateResponse(response.data, 'Gagal menonaktifkan unit.');
  }

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
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    if (value is Map) {
      final map = Map<String, dynamic>.from(value);

      for (final key in ['data', 'items', 'results']) {
        if (map.containsKey(key)) {
          return _extractList(map[key]);
        }
      }
    }

    return [];
  }
}
