import 'package:dio/dio.dart';
import 'package:elingk/core/network/api_client.dart';

class AdminComplaintCategoriesService {
  final Dio _dio = ApiClient.dio;

  static const String _categoryEndpoint = '/admin/complaint-categories';
  static const String _unitEndpoint = '/admin/units';

  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await _dio.get(_categoryEndpoint);
    final body = response.data;

    if (body is! Map) {
      throw Exception('Format respons kategori tidak valid.');
    }

    final rawData = body['data'];

    if (rawData is! List) {
      throw Exception(
        body['message']?.toString() ?? 'Data kategori tidak ditemukan.',
      );
    }

    return rawData
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getActiveUnits() async {
    final response = await _dio.get(
      _unitEndpoint,
      queryParameters: {'aktif': true, 'per_page': 100},
    );

    final body = response.data;

    if (body is! Map) {
      throw Exception('Format respons unit tidak valid.');
    }

    // UnitController mengembalikan data berbentuk pagination:
    // data: { current_page: 1, data: [...] }
    final pagination = body['data'];

    if (pagination is! Map || pagination['data'] is! List) {
      throw Exception(
        body['message']?.toString() ?? 'Daftar unit aktif tidak ditemukan.',
      );
    }

    return (pagination['data'] as List)
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<Map<String, dynamic>> createCategory({
    required int unitId,
    required String nama,
    String? deskripsi,
    required bool aktif,
  }) async {
    final response = await _dio.post(
      _categoryEndpoint,
      data: {
        'unit_id': unitId,
        'nama': nama.trim(),
        'deskripsi': _normalizeDescription(deskripsi),
        'aktif': aktif,
      },
    );

    return _extractData(response.data);
  }

  Future<Map<String, dynamic>> updateCategory({
    required int id,
    required int unitId,
    required String nama,
    String? deskripsi,
    required bool aktif,
  }) async {
    final response = await _dio.put(
      '$_categoryEndpoint/$id',
      data: {
        'unit_id': unitId,
        'nama': nama.trim(),
        'deskripsi': _normalizeDescription(deskripsi),
        'aktif': aktif,
      },
    );

    return _extractData(response.data);
  }

  Future<void> deleteCategory(int id) async {
    await _dio.delete('$_categoryEndpoint/$id');
  }

  Map<String, dynamic> _extractData(dynamic body) {
    if (body is Map) {
      final data = body['data'];

      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }

      return Map<String, dynamic>.from(body);
    }

    throw Exception('Format respons server tidak valid.');
  }

  String? _normalizeDescription(String? value) {
    final description = value?.trim();

    if (description == null || description.isEmpty) {
      return null;
    }

    return description;
  }
}
