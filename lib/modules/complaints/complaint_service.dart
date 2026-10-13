import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';

class ComplaintService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getComplaints({int page = 1}) async {
    final response = await _dio.get(
      '/complaints',
      queryParameters: {'page': page},
    );

    if (response.data is! Map) {
      throw Exception('Format respons pengaduan tidak valid.');
    }

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> getComplaintDetail(int id) async {
    final response = await _dio.get('/complaints/$id');

    if (response.data is! Map) {
      throw Exception('Format detail pengaduan tidak valid.');
    }

    return Map<String, dynamic>.from(response.data as Map);
  }
}
