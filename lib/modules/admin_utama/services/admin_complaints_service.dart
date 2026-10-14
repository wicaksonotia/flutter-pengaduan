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

    if (response.data is! Map) {
      throw Exception('Format respons pengaduan tidak valid.');
    }

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> getComplaintDetail(int id) async {
    final response = await _dio.get('/admin/complaints/$id');

    if (response.data is! Map) {
      throw Exception('Format respons detail pengaduan tidak valid.');
    }

    final result = Map<String, dynamic>.from(response.data as Map);

    if (result['status'] != 'success' || result['data'] is! Map) {
      throw Exception(result['message'] ?? 'Gagal mengambil detail pengaduan.');
    }

    return Map<String, dynamic>.from(result['data'] as Map);
  }
}
